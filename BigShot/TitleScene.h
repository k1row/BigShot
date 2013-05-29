//
//  TitleScene.h
//  BigShot
//
//  Created by Keiichiro Nagashima on 11/11/16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AMoAdView.h"


@interface TitleScene : CCLayerColor <AMoAdViewDelegate>
{
    CCMenuItemImage* _startItem;
    CCMenuItemImage* _facebookItem;
    CCLabelTTF* _wellcomeLabel;
    
    AMoAdView *ad;
}
+(id)titleScene;
+(TitleScene*)sharedTitleScene;


-(void)startGame:(CCMenuItem*)menuItem;  // メニューからのアクション
-(void)startFacebook:(CCMenuItem*)menuItem;
-(void)changeScoreWithScore:(int)score;  // ゲームが終わった時に呼ばれる


@end
