//
//  GameScene.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

- (id)init
{
  self = [super init];
  if (self) {
    //Game 레이어 추가하기
    _gameLayer = [GameLayer node];
    [self addChild:_gameLayer z:0];
    
  }
  return self;
}

@end
