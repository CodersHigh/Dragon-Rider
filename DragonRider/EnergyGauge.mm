//
//  EnergyGauge.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "EnergyGauge.h"


@implementation EnergyGauge

+(id)initWithMaxSize:(CGSize)size maxValue:(CGFloat)_maxValue{
  return [[self alloc] initWithMaxSize:size maxValue:_maxValue];
}

- (id)initWithMaxSize:(CGSize)size maxValue:(CGFloat)_maxValue{
  self = [super init];
  if ( self ){
    maxSize = size;
    currentValue = maxValue = _maxValue;
  }
  return self;
}

- (void)draw{
  //최대값 기준으로 % 로 환산한 너비 값
  CGFloat width = (currentValue / maxValue) * (float)maxSize.width;
  //라인의 두깨는 높이값이다.
  glLineWidth(maxSize.height);
  //100%일 때는 Green 값
  if (currentValue == maxValue) {
    ccDrawColor4B(255, 255, 0, 255);
    //그 외에는 Red 값
  } else {
    ccDrawColor4B(255, 0, 0, 255);
  }
  //선을 그린다.
  ccDrawLine(ccp(0, 0), ccp(width, 0));
}


- (void)updateBar:(CGFloat)_currentValue{
  //현재 값으로 할당한다. 0 이하면 0으로, 최대값을 초과하면 최대값으로 보정한다.
  currentValue = _currentValue;
  
  if (currentValue < 0 ) currentValue = 0;
  else if (currentValue > maxValue) currentValue = maxValue;
}

@end
