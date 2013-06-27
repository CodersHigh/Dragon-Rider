//
//  Dust.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "Dust.h"


@implementation Dust

- (id)init
{
  self = [super init];
  if (self) {
    self.anchorPoint = CGPointZero;
    //동일한 이미지의 반복 사용의 효율성을 위해서 배치노드 생성
    _batch = [CCSpriteBatchNode batchNodeWithFile:@"dragonRideSprite.pvr.ccz"];
    //배치노드 추가
    [self addChild:_batch];
    
    // 먼지 효과 초기화
    [self initDust];
    
    // 폭발 효과 초기화
    [self initExplosion];
  }
  return self;
}

#define kMaxDust 10

-(void)initDust{
  //10개의 먼지 이미지를 사용할 배열을 만든다.
  dusts = [CCArray arrayWithCapacity:kMaxDust];
  for ( int i = 0 ; i < kMaxDust; i++ ) {
    //먼지 이미지를 스프라이트 시트에서 가져온다.
    CCSprite *dust = [CCSprite spriteWithSpriteFrameName:@"dust.png"];
    //애니메이션 될때 보여 주기 위해 처음에는 숨긴다.
    dust.visible = NO;
    //작은거에서 커지는 애니메이션을 위해 1/10 으로 작게 만든다.
    //스케일 설정
    dust.scale = 1.0/10.0;
    //배치 노드에 자식 노드로 추가 한다.
    [_batch addChild:dust];
    //배열에 먼지를 추가한다.
    [dusts addObject:dust];
  }
}

-(void)initExplosion{
  //플레이어 캐릭터가 폭발될 때의 스프라이트를 위한 배열
  explosions = [CCArray arrayWithCapacity:kMaxDust];
  
  //폭발 스프라이트
  CCSprite *explosion = [CCSprite spriteWithSpriteFrameName:@"explosion.png"];
  //폭발시에만 보이게, 숨김 처리
  explosion.visible = NO;
  //터지는 효과를 위해 작게 설정한다.
  explosion.scale = 0.5;
  [self addChild:explosion];
  [explosions addObject:explosion];
}

-(void)animateExplosions{
  //배열에서 각각의 폭발 스프라이트를 꺼낸다.
  for (CCSprite *explosion in explosions) {
    //보이게 설정을 한다.
    explosion.visible = YES;
    //0.4 초 동안 3배 커지게 설정
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.4 scale:3.0];
    //애니메이션이 끝나면 숨기고, 삭제한다.
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
      explosion.visible = NO;
      [self removeFromParentAndCleanup:YES];
    }];
    //움직임 애니메이션이 끝나면 block을 순차적으로 실행하기 위한 시퀀시 생성
    CCSequence *seq = [CCSequence actions:scale, block, nil];
    [explosion runAction:seq];
  }
}

-(void)animateDusts{
  //애니메이션을 위해서 먼지를 세팅
  for (CCSprite *dust in dusts) {
    //숨긴 이미지를 다시 보이게 함
    dust.visible = YES;
    
    //10개의 이미지의 크기를 랜덤으로 가져옴
    float scaleRandom = 0.1 + ( (double)arc4random() / (double)0xffffffff );
    //0.3 초 시간동안 크기 변경 애니메이션
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.3 scale:scaleRandom];
    
    // 터지는 x위치를 위해서 랜덤 값 1 or -1
    int x = ( (double)arc4random() / (double)0xffffffff ) < 0.5 ? -1 : +1;
    float xRandom = 5 + 4 * ( ((double)arc4random()/(double)0xffffffff) * 10 * x );
    // 터지는 y위치를 위해서 랜덤 값 1 or -1
    int y = ( (double)arc4random() / (double)0xffffffff ) < 0.5 ? -1 : +1;
    float yRandom = -30 + 4 * ( ((double)arc4random() / (double)0xffffffff ) * 10 * y );
    
    //0.3 초 시간동안 위치 변경 애니메이션
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.3 position:ccp(xRandom, yRandom)];
    
    //애니메이션이 끝나면 숨기고 자신은 삭제를 위해서 블럭 함수 생성
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
      dust.visible = NO;
      [self removeFromParentAndCleanup:YES];
    }];
    
    //움직임 애니메이션이 끝나면 block을 순차적으로 실행하기 위한 시퀀시 생성
    CCSequence *seq = [CCSequence actions:move, block, nil];
    //runAction은 연이어 하면 동시에 크기와 움직임 엑션이 일어난다.
    [dust runAction:scale];
    [dust runAction:seq];
  }
}
@end

