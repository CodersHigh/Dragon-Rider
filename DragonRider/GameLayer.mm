//
//  GameLayer.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer

-(id)init
{
  self = [super init];
  if (self) {
    //윈도우 화면 크기를 가져온다.
    winSize = [[CCDirector sharedDirector] winSize];
    
    //스프라이트 프레임 캐쉬에 스프라이트를 저장한다.
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dragonRideSprite.plist"];
    
    //배경 초기화
    [self initBackground];
    
    //플레이어 캐릭터 초기화
    [self initPlayer];
  }
  return self;
}

-(void)initBackground{
  //배경에 사용할 1번 이미지를 생성 후, 화면에 꽉 차게 이동 시킨다.
  _backgroundImage1 = [CCSprite spriteWithFile:@"background.png"];
  _backgroundImage1.anchorPoint = CGPointZero;
  [self addChild:_backgroundImage1 z:-1];
  
  //배경에 사용할 2번 이미지를 생성 후, 1번 이미지 위로 이동 시킨다.
  _backgroundImage2 = [CCSprite spriteWithFile:@"background.png"];
  _backgroundImage2.anchorPoint = CGPointZero;
  _backgroundImage2.position = ccp(0, [_backgroundImage2 boundingBox].size.height);
  [self addChild:_backgroundImage2 z:-1];
}

- (void)update:(ccTime)dt {
  // 배경화면 움직이는 속도, 현재 위치에 이동할 위치를 ccpAdd로 더하는 방식
  CGPoint backgroundScrollVel = ccp(0, -100);
  // 현재 이미지1의 위치 값을 불러온다.
  CGPoint currentPos = [_backgroundImage1 position];
  // 1번 이미지가 스크롤 되서 사라지고, 2번 이지미가 1번 이미지의 초기 위치에 오면 최초위치로 이동
  
  if (currentPos.y < -winSize.height) {
    [_backgroundImage1 setPosition: CGPointZero];
    currentPos = ccp(0, [_backgroundImage2 boundingBox].size.height);;
    [_backgroundImage2 setPosition: currentPos];
    //현재 위치에서 backgroundScrollVel을 더 한다.
  } else{
    _backgroundImage1.position = ccpAdd(ccpMult(backgroundScrollVel, dt), _backgroundImage1.position);
    _backgroundImage2.position = ccpAdd(ccpMult(backgroundScrollVel, dt), _backgroundImage2.position);
  }
}

- (void)initPlayer {
  //플레이어 캐릭터를 생성한다.
  _player = [Player node];
  //가장 위에 위치 시킨다.
  [self addChild:_player z:99];
}

- (void)onEnter {
  [super onEnter];
  //배경 움직임을 위한 메인 스케쥴
  [self scheduleUpdate];
  //터치 이벤트를 받는다.
  [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

#pragma mark Touch

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  //터치가 시작되면 이전 값과 비교를 위해 저장한다. UI좌표계를 cocos 좌표계로 변환
  previousPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
  return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  // 이전 값과 비교를 위한 움직였을때 위치 값. UI좌표계를 cocos 좌표계로 변환
  CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
  //플레이어 캐릭터의 위치를 계산한다. ( 기존 위치 X축 값 - 움직인 거리 ), Y축 값은 동일
  _player.position = ccp( _player.position.x - (previousPoint.x - location.x) * 2, _player.position.y );
  //왼쪽이나 오른쪽으로 벗어나면 넘어가지 않도록 고정 시킨다.
  if (_player.position.x < 0) {
    _player.position = ccp(0, _player.position.y);
  } else if (_player.position.x > winSize.width) {
    _player.position = ccp(winSize.width, _player.position.y);
  }
  //현재 위치를 이전 값으로 저장한다.
  previousPoint = location;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  //터치가 끝났을때는 특별한 이벤트가 없다.
}

@end
