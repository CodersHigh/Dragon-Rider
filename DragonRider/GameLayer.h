//
//  GameLayer.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer {
  //화면 크기를 저장
  CGSize winSize;
}

//두 장의 배경 스프라이트
@property (nonatomic, weak) CCSprite *backgroundImage1;
@property (nonatomic, weak) CCSprite *backgroundImage2;

@end
