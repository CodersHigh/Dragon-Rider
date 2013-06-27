//
//  Player.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "Player.h"


@implementation Player

- (id)init
{
  //플레이어 몸통의 스프라이트를 생성한다.
  self = [super initWithSpriteFrameName:@"player.png"];
  if (self) {
    //윈도우 크기 값
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //화면의 가운데 아래측에 위치 시킨다.
    self.position = ccp( winSize.width/2, 50 );
    
    //왼쪽 날개를 만든다.
    _leftWing = [CCSprite spriteWithSpriteFrameName:@"player_wing.png"];
    //날개 펄럭이는 애니메이션을 위해서 날개의 엥커포인트를 우측 상단으로 한다.
    _leftWing.anchorPoint = ccp( 1.0, 1.0 );
    //중간 정도로 위치 시킨다.
    _leftWing.position = ccp( 5, 60 );
    //날개가 몸통아래에 위치 하도록 z-order를 변경한다.
    [self addChild:_leftWing z:-1];
    
    //오른쪽 날개를 만든다.
    _rightWing = [CCSprite spriteWithSpriteFrameName:@"player_wing.png"];
    //날개 펄럭이는 애니메이션을 위해서 날개의 엥커포인트를 촤측 상단으로 한다.
    _rightWing.anchorPoint = ccp( 0.0, 1.0 );
    //Flip 회전 시킨다.
    [_rightWing setFlipX:YES];
    //Flip 회전 하면 축으로 회전 된다. 그래서 몸통의 가로만큼 추가해준다.
    _rightWing.position = ccp( self.boundingBox.size.width - 5, 60 );
    //날개가 몸통아래에 위치 하도록 z-order를 변경한다.
    [self addChild:_rightWing z:-1];
  }
  return self;
}

-(void)updateWings:(ccTime)dt{
  //왼쪽 날개 애니메이션을 위한 날개 내렸다 올리기
  CCRotateTo *leftWingDown = [CCRotateTo actionWithDuration:0.2 angleX:-30 angleY:60];
  CCRotateTo *leftWingUp = [CCRotateTo actionWithDuration:0.2 angleX:0 angleY:0];
  //오른쪽 날개 애니메이션을 위한 날개 내렸다 올리기
  CCRotateTo *rightWingDown = [CCRotateTo actionWithDuration:0.2 angleX:30 angleY:-60];
  CCRotateTo *rightWingUp = [CCRotateTo actionWithDuration:0.2 angleX:0 angleY:0];
  
  //날개짓을 번갈아 가기 위해
  if ( (wingDown = !wingDown) ){
    [_leftWing runAction:leftWingDown];
    [_rightWing runAction:rightWingDown];
  }else{
    [_leftWing runAction:leftWingUp];
    [_rightWing runAction:rightWingUp];
  }
}

-(void)onEnter{
  [super onEnter];
  // 날개짓을 위한 0.2초 마다 메소드 호출
  [self schedule:@selector(updateWings:) interval:0.2];
}

#define PTM_RATIO 16

-(void) createBox2dObject:(b2World*)world {
  b2BodyDef playerBodyDef;
	playerBodyDef.type = b2_dynamicBody;
	playerBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
	playerBodyDef.userData = (__bridge void*)self;
	playerBodyDef.fixedRotation = true;
  
	_body = world->CreateBody(&playerBodyDef);
}

@end
