//
//  Player.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite {
  BOOL wingDown;
}

@property (nonatomic, weak) CCSprite *leftWing;
@property (nonatomic, weak) CCSprite *rightWing;

@end
