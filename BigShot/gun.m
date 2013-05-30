//
//  Gun.m
//  BigShot
//
//  Created by k16 on 11/11/15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Gun.h"


@implementation Gun
static Gun* instanceOfGun;


+(Gun*)sharedGun
{
    NSAssert (instanceOfGun != nil, @"Gun ins not yet initialized!");
    return instanceOfGun;
}

+(id)gun
{
    return [[[self alloc] initWithGunImage] autorelease];
}

-(id)initWithGunImage
{
    if (self = [super initWithFile:@"gunLeft.png"])
    {
        instanceOfGun = self;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.position = CGPointMake(winSize.width / 2, winSize.height /2);
    }
    return self;
}

-(void)changeGunWithFlipX:(BOOL)flipBool
{
    CCFlipX* flipx = [CCFlipX actionWithFlipX:flipBool];
    [self runAction:flipx];
}

@end
