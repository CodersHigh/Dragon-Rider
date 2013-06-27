//
//  Bullet.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//총알의 종류와 강도
typedef enum {
  //총알의 강도를 나타낸다.
  kFirst = 20
} BulletType;

@interface Bullet : CCSprite {
  
}

@property (nonatomic, readwrite) BulletType bulletType;

@end
