//
//  GameScene.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "HUDLayer.h"

@interface GameScene : CCScene {
    
}

@property (nonatomic, weak) GameLayer *gameLayer;
@property (nonatomic, weak) HUDLayer *hudLayer;

@end
