//
//  Gun.h
//  BigShot
//
//  Created by k16 on 11/11/15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Gun : CCSprite
{    
}
+(Gun*)sharedGun;
+(id)gun;
-(id)initWithGunImage;

-(void)changeGunWithFlipX:(BOOL)flipBool;

@end
