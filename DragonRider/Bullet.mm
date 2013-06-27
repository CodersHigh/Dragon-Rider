//
//  Bullet.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "Bullet.h"


@implementation Bullet

- (id)init
{
  //첫 번째 총알 이미지
  self = [super initWithSpriteFrameName:@"bullet_01.png"];
  if (self) {
    //총알 종류를 설정한다
    _bulletType = kFirst;
  }
  return self;
}

- (void)updateBullet:(ccTime)dt {
  CGSize winSize = [[CCDirector sharedDirector] winSize];
  //총알의 움직임 가속도
  CGPoint bulletVel = ccp(0, 300);
  //총알의 현재위치
  CGPoint currentPostion = self.position;
  //화면 밖으로 넘어가면 총알을 숨긴다.
  if (currentPostion.y > winSize.height){
    self.visible = NO;
  } else{
    //아니면 계속해서 앞으로 보낸다.
    self.position = ccpAdd(ccpMult(bulletVel, dt), self.position);
  }
}

-(void)onEnter{
  [super onEnter];
  //스케쥴러 호출
  [self schedule:@selector(updateBullet:) interval:0.05];
}

@end
