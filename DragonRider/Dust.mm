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
  //Autorelease 부분 삭제
  CCParticleSystem *particle = [CCParticleSystemQuad particleWithTotalParticles:1000];
  
  //이미지 이름 변경
  CCTexture2D *texture=[[CCTextureCache sharedTextureCache] addImage:@"particle.png"];
  particle.texture=texture;
  particle.emissionRate=2000.00;
  particle.angle=90.0;
  particle.angleVar=360.0;
  ccBlendFunc blendFunc={GL_ONE,GL_ONE_MINUS_SRC_ALPHA};
  particle.blendFunc=blendFunc;
  particle.duration=0.05;
  particle.emitterMode=kCCParticleModeGravity;
  ccColor4F startColor={0.70,0.10,0.20,1.00};
  particle.startColor=startColor;
  ccColor4F startColorVar={0.50,0.50,0.50,0.00};
  particle.startColorVar=startColorVar;
  ccColor4F endColor={0.50,0.50,0.50,0.00};
  particle.endColor=endColor;
  ccColor4F endColorVar={0.50,0.50,0.50,0.00};
  particle.endColorVar=endColorVar;
  particle.startSize=20.00;
  particle.startSizeVar=20.00;
  particle.endSize=-1.00;
  particle.endSizeVar=0.00;
  particle.gravity=ccp(0.00,0.00);
  particle.radialAccel=0.00;
  particle.radialAccelVar=0.00;
  particle.speed=70;
  particle.speedVar=40;
  particle.tangentialAccel= 0;
  particle.tangentialAccelVar= 0;
  particle.totalParticles=1000;
  particle.life=0.50;
  particle.lifeVar=0.50;
  particle.startSpin=0.00;
  particle.startSpinVar=0.00;
  particle.endSpin=0.00;
  particle.endSpinVar=0.00;
  //position 변경
  particle.position=ccp(0.00,0.00);
  particle.posVar=ccp(0.00,0.00);
  
  //자신에 추가한다.
  [self addChild:particle];
  //1초 뒤에 부모노드에서 삭제한다.
  [self scheduleOnce:@selector(removeFromParent) delay:1.0];
}
@end

