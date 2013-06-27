//
//  Dust.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Dust : CCSprite {
  CCArray *dusts; // 먼지 효과
  CCArray *explosions; // 폭발 효과
}

@property (nonatomic, weak) CCSpriteBatchNode *batch;

-(void)animateDusts; // 먼지 효과 애니메이션
-(void)animateExplosions; // 폭발 효과 애니메이션
@end
