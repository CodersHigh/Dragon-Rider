//
//  Enemy.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "Enemy.h"


@implementation Enemy

- (id)init
{
  //몬스터 스프라이트를 위한 기본 이미지를 추가한다.
  self = [super initWithSpriteFrameName:@"dragon_01_body.png"];
  if (self) {
    //기본상태로 설정
    _state = kNormal;
    //적의 기본 에너지는 100
    _energy = 100;
    
    //왼쪽 날개 스프라이트
    _leftWing = [CCSprite spriteWithSpriteFrameName:@"dragon_01_wing.png"];
    //날개짓 회전 애니메이션을 위해서 축을 우측 하단으로 설정
    _leftWing.anchorPoint = ccp( 1.0, 0 );
    //중간 정도로 위치 시킨다.
    _leftWing.position = ccp( 10, self.boundingBox.size.height / 2 );
    [self addChild:_leftWing];
    
    //오른쪽 날개 스프라이트
    _rightWing = [CCSprite spriteWithSpriteFrameName:@"dragon_01_wing.png"];
    //동일한 이미지를 반대도 회전 시켜서 사용
    _rightWing.flipX = YES;
    //날개짓 회전 애니메이션을 위해서 축을 우측 하단으로 설정
    _rightWing.anchorPoint = ccp( 0.0, 0 );
    //중간 정도로 위치 시킨다.
    _rightWing.position = ccp( self.boundingBox.size.width - 10, self.boundingBox.size.height / 2 );
    [self addChild:_rightWing];
  }
  return self;
}

-(void)update:(ccTime)dt {
  // 1. 적의 움직임 가속도 값
  CGPoint enemyScrollVel = ccp(0, -250);
  // 2. 현재 적의 위치 값
  CGPoint enemyPos = [self position];
  // 3. 화면 아래로 벗어나는지 체크
  if (enemyPos.y + self.boundingBox.size.height / 2 <= 0) {
    //벗어나면 리셋 한다.
    [self reset];
    //아닐 경우
  } else{
    //움직이게 위치값을 아래로 이동
    enemyPos = ccpAdd(ccpMult(enemyScrollVel, dt), enemyPos);
    //위치 시킨다.
    [self setPosition:enemyPos];
  }
}

#define kMaxEnemyType 2

-(void)reset {
  //죽어서 안보이던 적을 다시 보여준다.
  [self setVisible:YES];
  //상태값을 일반 상태로 변경 한다.
  _state = kNormal;
  
  CGSize winSize = [[CCDirector sharedDirector] winSize];
  //적의 위치를 화면 상단으로 부터 시작한다.
  self.position = ccp( self.position.x, winSize.height + self.boundingBox.size.height / 2 - 1 );
  //적의 이미지를 바꿔주기 위해 랜덤 값 생성
  int random = ( (float)arc4random() / (float)0xffffffff ) * kMaxEnemyType;
  
  switch (random) {
    case kWhite:
      //에너지를 100으로 할당
      _energy = 100;
      //적의 타입설정
      _enemyType = kWhite;
      //이미지 변경을위해 프레임에 파일이름으로 스프라이트 프레임 케쉬로 부터 찾아서 할당
      [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dragon_01_body.png"]];
      [_leftWing setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dragon_01_wing.png"]];
      [_rightWing setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dragon_01_wing.png"]];
      _rightWing.flipX = YES;
      break;
    case kRed:
      //에너지를 200으로 할당
      _energy = 200;
      //적의 타입설정
      _enemyType = kRed;
      //프레임에 파일이름으로 스프라이트 프레임 케쉬로 부터 찾아서 할당
      [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dragon_02_body.png"]];
      [_leftWing setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dragon_02_wing.png"]];
      [_rightWing setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dragon_02_wing.png"]];
      _rightWing.flipX = YES;
      break;
    default:
      break;
  }
}

-(void)onEnter{
  [super onEnter];
  //스케쥴러 호출
  [self scheduleUpdate];
}

@end
