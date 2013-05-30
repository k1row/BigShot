//
//  Target.h
//  BigShot
//
//  Created by k16 on 11/11/15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum
{
    kTagParticle,
};


@interface Target : CCSprite 
{    
    int _targetNum;
    CCLabelTTF* _targetNumLabel;
}

+(id)target;
-(id)initWithTargetImage;

-(void)setTargetNum:(int)num;
-(int)getTargetNum;


@end
