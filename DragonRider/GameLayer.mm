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
    
    //배경 초기화
    [self initBackground];
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

- (void)onEnter {
  [super onEnter];
  //배경 움직임을 위한 메인 스케쥴
  [self scheduleUpdate];
}

@end
