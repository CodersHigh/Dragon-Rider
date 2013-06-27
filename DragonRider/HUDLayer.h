//
//  HUDLayer.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HUDLayer : CCLayer {
//  CCLabelTTF *scoreLabel; // 점수를 위한 레이블
  CCLabelBMFont *scoreLabel; // 점수를 위한 레이블
}

-(void)setScoreText:(int)score;

@end
