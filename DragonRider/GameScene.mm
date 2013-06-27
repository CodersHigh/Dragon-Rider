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
    
    //HUD 레이어 추가하기
    _hudLayer = [HUDLayer node];
    [self addChild:_hudLayer z:1];
    
    //게임 레이어의 HUD에 HUD레이어 전달
    self.gameLayer.hud = _hudLayer;

  }
  return self;
}

@end
