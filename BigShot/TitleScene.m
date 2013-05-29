//
//  TitleScene.m
//  BigShot
//
//  Created by Keiichiro Nagashima on 11/11/16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import "RootViewController.h"

//#import "FaceBookScene.h"


@implementation TitleScene

static TitleScene* instanceOfTitleScene;

+(TitleScene*)sharedTitleScene
{
    NSAssert(instanceOfTitleScene != nil, @"TitleScene instance not yet initialized!");
    return instanceOfTitleScene;
}

+(id)titleScene
{
    return [[[self alloc] init] autorelease];
}

-(id)init
{
    if (self = [super initWithColor:ccc4(0, 0, 0, 230)])
    {
        instanceOfTitleScene = self;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"BigShot" fontName:@"Marker Felt" fontSize:60];
        titleLabel.position = CGPointMake (winSize.width / 2, winSize.height - winSize.height / 4);
        [self addChild:titleLabel];
        
        _wellcomeLabel = [CCLabelTTF labelWithString:@"Wellcome!!" fontName:@"Marker Felt" fontSize:46];
        _wellcomeLabel.position = CGPointMake (winSize.width / 2, winSize.height / 2);
        [self addChild:_wellcomeLabel];
        
        _startItem = [CCMenuItemImage itemFromNormalImage:@"start.png" selectedImage:@"start.png" target:self selector:@selector(startGame:)];
        
        CCMenu* menu = [CCMenu menuWithItems:_startItem,nil];
        menu.position = CGPointMake (winSize.width / 2, winSize.height / 3);
        [self addChild:menu];
 
        _facebookItem = [CCMenuItemImage itemFromNormalImage:@"facebook.png" selectedImage:@"facebook.png" target:self selector:@selector(startFacebook:)];
        
        CCMenu* menuF = [CCMenu menuWithItems:_facebookItem,nil];
        menuF.position = CGPointMake (winSize.width / 2, winSize.height / 5);
        [self addChild:menuF];
        
        ad = [[[AMoAdView alloc] initWithFrame:CGRectZero] autorelease];
        ad.currentContentSizeIdentifier = AMoAdContentSizeIdentifierPortrait;
        ad.sid = @"b933b6ed285c118e8bfbfe360c8b7e362b8be11765881618eefb58d1387d8f4f";
        ad.enableRotation = YES;
        ad.backgroundColor = [UIColor clearColor];
        ad.delegate = self;
        ad.rotationAnimationTransition = AMoAdViewAnimationTransitionFlipFromLeft;
        ad.clickAnimationTransition = AMoAdViewClickAnimationTransitionJump;
        
        //ローテーションをしないならstartRotationの代わりにdisplayAdを呼ぶ
        [ad startRotation];
        //[ad displayAd];

        RootViewController *viewController = (RootViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        [viewController.view addSubview:ad];
    }

    return self;
}

#pragma mark --
#pragma mark メニューからのアクション
-(void)startGame:(CCMenuItem *)menuItem
{
    CCLOG(@"startGame");
    self.visible = NO;
    [[GameScene sharedGameScene] gameStart];
}

-(void)startFacebook:(CCMenuItem *)menuItem
{
    CCLOG(@"startFacebook");
    self.visible = NO;
    //[[FaceBookScene sharedFaceBookScene] facebookStart];
	//[[CCDirector sharedDirector] pushScene:[FaceBookScene scene]];

}


#pragma mark --
#pragma mark 表示を変える
- (void)changeScoreWithScore:(int)score
{
    [_wellcomeLabel setString:[NSString stringWithFormat:@"Score : %d", score]];
}


@end
