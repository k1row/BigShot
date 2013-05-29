//
//  GameScene.h
//  BigShot
//
//  Created by Keiichiro Nagashima on 11/11/15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum
{
    kTagZIndexTitleScene = 100,
};

@class Target;


@interface GameScene : CCLayer
{
    BOOL _touchEnable;
    
    Target* _targetLeft;
    Target* _targetRight;
    
    // スコア関係
    CCLabelTTF* _highScoreLabel;
    CCLabelTTF* _scoreLabel;
    int _highScore;
    int _nowScore;
    
    // ゲームサイクル関連
    CCLabelTTF* _timerLabel;
    float _timer;
}

+(id)scene;
+(GameScene*)sharedGameScene;
-(void)setTarget;
-(void)touchRightOrNot:(BOOL)boolean;

// スコア関係
-(void)setScore;
-(void)updateScore:(int)score;
-(void)setHighScore:(int)score;

// ゲームサイクル関連
-(void)gameStart;
-(void)updateTimer;
-(void)gameOver;

@end
