//
//  EnergyGauge.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnergyGauge : CCNode {
  CGFloat maxValue;
  CGFloat currentValue;
  CGSize maxSize;
}

+ (id)initWithMaxSize:(CGSize)size maxValue:(CGFloat)_maxValue;
- (id)initWithMaxSize:(CGSize)size maxValue:(CGFloat)maxVal;
- (void)updateBar:(CGFloat)_currentValue;

@end
