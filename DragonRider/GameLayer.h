//
//  GameLayer.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "HUDLayer.h"
#import "Box2D.h"
#import "MyContactListener.h"

@interface GameLayer : CCLayer {
  //화면 크기를 저장
  CGSize winSize;
  
  //이전 위치값 저장
  CGPoint previousPoint;
  
  //적을 담을 배열
  CCArray *enemysArray;
  
  //총알을 담을 배열
  CCArray *bulletsArray;
  //마지막 총알 확인용
  int lastBullet;
  
  // 충돌된 상태인지를 체크
  BOOL isCollision;
  
  //점수를 위한 변수
  int score;
  
  //Box2D를 위한 변수
  b2World* world;
  MyContactListener *contactListener;
}

//두 장의 배경 스프라이트
@property (nonatomic, weak) CCSprite *backgroundImage1;
@property (nonatomic, weak) CCSprite *backgroundImage2;
//플레이어 캐릭터 스프라이트
@property (nonatomic, weak) Player *player;
//배치노드
@property (nonatomic, weak) CCSpriteBatchNode *batchNode;
@property (nonatomic, weak) HUDLayer *hud;

-(void)collisionPlayerWithEnemy;

@end
