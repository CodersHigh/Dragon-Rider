//
//  Enemy.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EnergyGauge.h"

//두 종류의 적
typedef enum {
  kRed = 0,
  kWhite
} EnemyType;

//적의 상태
typedef enum {
  kDestoryed = 0,
  kNormal = 1
} State;

@interface Enemy : CCSprite {
  
}

//적의 종류 : 약한놈과 강한놈으로 두 가지로만 구분
@property (nonatomic) EnemyType enemyType;
//현재 상태 값 : 죽었는지, 살았는지로 구분
@property (nonatomic) State state;
//에너지
@property (nonatomic) NSInteger energy;
//왼쪽 날개
@property (nonatomic, weak) CCSprite *leftWing;
//오른쪽 날개
@property (nonatomic, weak) CCSprite *rightWing;
//에너지 게이지
@property (nonatomic, strong) EnergyGauge *gauge;

-(void)reset;
-(NSInteger)attackedWithPoint:(NSInteger)point;

@end
