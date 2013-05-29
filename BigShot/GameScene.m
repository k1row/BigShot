//
//  GameScene.m
//  BigShot
//
//  Created by Keiichiro Nagashima on 11/11/15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "TitleScene.h"
#import "Gun.h"
#import "Target.h"


@implementation GameScene

static GameScene* instanceOfGameScene;

-(id)init
{
    if (self = [super init])
    {
        instanceOfGameScene = self;
        
        // タップは最初は不可能
        _touchEnable = NO;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // タイトルを作る
        TitleScene* titleScene = [TitleScene titleScene];
        [self addChild:titleScene z:kTagZIndexTitleScene];
        
        // 背景イメージからCCSpriteを作る
        CCSprite* backgroundImage = [CCSprite spriteWithFile:@"stage.png"];
        
        // cocos2dではアンカーポイントが左上ではなく中心にあるので注意
        backgroundImage.position = CGPointMake (winSize.width / 2, winSize.height / 2);
        
        //GameSceneに背景を載せる
        [self addChild:backgroundImage];
                
        // Target
        // 左のターゲットを作る
        _targetLeft = [Target target];
        _targetLeft.position = CGPointMake (winSize.width / 4, winSize.height / 2 + winSize.height / 12);
        [self addChild:_targetLeft];
        
        // 右のターゲットを作る
        _targetRight = [Target target];
        _targetRight.position = CGPointMake (winSize.width / 4 + winSize.width / 2, winSize.height / 2 + winSize.height / 12);
        [self addChild:_targetRight];

        // Gun
        Gun* gun = [Gun gun];
        [self addChild:gun];

        // Scoreをセットする
        int fontSize = 18;
        _highScoreLabel = [CCLabelTTF labelWithString:@"High Score : 000" fontName:@"Marker Felt" fontSize:fontSize];
        _highScoreLabel.position = CGPointMake(0, winSize.height/4);
        _highScoreLabel.anchorPoint = CGPointMake(0, 1); // 左下上に設定
        [self addChild:_highScoreLabel];
        
        CCLabelTTF* spaceLabel = [CCLabelTTF labelWithString:@"High " fontName:@"Marker Felt" fontSize:fontSize];

        _scoreLabel = [CCLabelTTF labelWithString:@"Score : 000" fontName:@"Marker Felt" fontSize:fontSize];
        _scoreLabel.position = CGPointMake(spaceLabel.contentSize.width, winSize.height/4-_highScoreLabel.contentSize.height);
        _scoreLabel.anchorPoint = CGPointMake(0, 1); // 左下上に設定
        [self addChild:_scoreLabel];
        
        // 変数の初期化
        _nowScore = 0;
        _highScore = 0;
        [self setScore];
        
        // ゲームサイクル
        _timerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.01f",10.0f] fontName:@"Marker Felt" fontSize:64];
        _timerLabel.position = CGPointMake (winSize.width / 2, winSize.height - winSize.height / 6);
        [self addChild:_timerLabel];
        
        
        //[self gameStart];
    }
    return self;
}

-(void)setTarget
{
    [self unschedule:@selector(setTarget)];
    int leftNum = floor (CCRANDOM_0_1() * 8 + 1);
    [_targetLeft setTargetNum:leftNum];
    
    int rightNum = floor (CCRANDOM_0_1() * 8 + 1);
    while (rightNum == leftNum)
    {
        rightNum = floor (CCRANDOM_0_1() * 8 + 1);
    }
    [_targetRight setTargetNum:rightNum];
}

// 起動時にスコアを表示する
-(void)setScore
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    _highScore = [defaults integerForKey:@"highScore"];
    [_highScoreLabel setString:[NSString stringWithFormat:@"High Score : %d", _highScore]];
}

// ゲーム中にスコアを更新するごとに呼び出される
-(void)updateScore:(int)score
{
    if (_highScore < score)
    {
        _highScore = score;
        [_highScoreLabel setString:[NSString stringWithFormat:@"High Score : %d", _highScore]];
    }
    [_scoreLabel setString:[NSString stringWithFormat:@"Score : %d", _nowScore]];
}

// ゲームが終わった時にハイスコアを保存する
-(void)setHighScore:(int)score
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_highScore forKey:@"highScore"];
    [defaults synchronize];
}

-(void)gameStart
{
    // タップを可能にする
    _touchEnable = YES;
    
    
    // ターゲットの初期化
    [self setTarget];
    
    // スコアの初期化
    _nowScore = 0;
    
    // タイマーの初期化
    _timer = 10.0;
    
    // タイマーを0.1秒間隔で回す
    [self schedule:@selector(updateTimer) interval:0.1];
}

-(void)updateTimer
{
    _timer -= 0.1;
    if (_timer <= 0.0)
    {
        _touchEnable = NO;

        // -0.0と表示されてしまうため0の時は特別に。
        [_timerLabel setString:[NSString stringWithFormat:@"0.0"]]; 
        
        // タイマーを止める
        [self unschedule:@selector(updateTimer)];
        
        // gameoverの呼び出し
        [self gameOver];
        return;
    }
    
    [_timerLabel setString:[NSString stringWithFormat:@"%.01f",_timer]];
}

-(void)gameOver
{
    // ハイスコアを更新する
    [self setHighScore:_nowScore];
    
    // TitleSceneにスコアを表示する
    [[TitleScene sharedTitleScene] changeScoreWithScore:_nowScore];
    
    // TitleSceneを表示する
    [TitleScene sharedTitleScene].visible = YES;
}

-(void)touchRightOrNot:(BOOL)boolean
{
    // booleanがYESの時は右、NOの時は左
    int leftNum = [_targetLeft getTargetNum];
    int rightNum = [_targetRight getTargetNum];
    
    CCLOG(@"Left : %d", leftNum);
    CCLOG(@"Right : %d", rightNum);
    
    if ((boolean && rightNum > leftNum) ||
        (!boolean && rightNum <= leftNum))
    {
        CCLOG(@"○正解");
        _nowScore++;
        
        // 正解した時の効果をつける
        if (boolean)
            [_targetRight targetActionWithCollect:YES];
        else
            [_targetLeft targetActionWithCollect:YES];
        
        // ターゲットの初期化
        [self schedule:@selector(setTarget) interval:0.1];
    }
    else
    {
        CCLOG(@"×不正解");
        _nowScore -= 2;
        
        if (boolean)
            [_targetRight targetActionWithCollect:NO];
        else
            [_targetLeft targetActionWithCollect:NO];
    }
    
    [self updateScore:_nowScore];
}

+(GameScene*)sharedGameScene
{
    NSAssert (instanceOfGameScene != nil, @"GameScene ins not yet initialized!");
    return instanceOfGameScene;
}

+(id)scene
{
    CCScene* scene = [CCScene node];
    CCLayer* layer = [GameScene node];
    [scene addChild:layer];
    return scene;
}

// レイヤーの表示時に呼ばれる
- (void)onEnter
{
    // タッチを感知してselfに通知。優先順位は０。
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

// レイヤーの非表示時に呼ばれる
- (void)onExit
{
    // タッチを感知するのをやめる
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

// タッチが始まった
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // タッチ可能かどうか
    return _touchEnable;
}

// タッチが動いている
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

// タッチが終わった
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // タッチの最後に指を話した場所を取得
    CGPoint touchEndPoint = [touch locationInView:[touch view]];
    Gun* gun = [Gun sharedGun];
    if (touchEndPoint.x < winSize.width / 2)
    {
        // 画面の左よりなら
        CCLOG(@"Over left");
        [gun changeGunWithFlipX:NO];
        
        // 当たり判定
        [self touchRightOrNot:NO];
    }
    else
    {
        // 画面の右よりなら
        CCLOG(@"Over right");
        [gun changeGunWithFlipX:YES];
        
        // 当たり判定
        [self touchRightOrNot:YES];
    }
}

@end
