//
//  MenuLayer.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "MenuLayer.h"
#import "GameScene.h"

@implementation MenuLayer

+(CCScene *)scene{
  //scene은 오토릴리스 오브젝트이다.
  CCScene *scene = [CCScene node];
  //layer는 오토릴리스 오브젝트이다.
  MenuLayer *layer = [MenuLayer node];
  //scene의 자식으로 layer를 추가한다.
  [scene addChild:layer];
  //scene을 리턴한다.
  return scene;
}

- (id)init
{
  self = [super init];
  if (self) {
    //다이렉터에서 화면의 크기를 알아온다.
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    //배경화면 스프라이트 설정
    CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"Default.png"];
    backgroundSprite.anchorPoint = ccp(0, 0);
    [self addChild:backgroundSprite];
    
    //이미지를 사용해서 기본, 선택되었을 때 메뉴 아이템 생성
    CCMenuItemImage *startItem = [CCMenuItemImage itemWithNormalImage:@"start_btn_normal.png" selectedImage:@"start_btn_selected.png" disabledImage:nil block:^(id sender) {
      [[CCDirector sharedDirector] replaceScene:[GameScene node]];
    }];
    //메뉴 버튼을 메뉴에 추가한다.
    CCMenu *menu = [CCMenu menuWithItems:startItem, nil];
    //세로 정렬로 각 메뉴의 사잇값으로 20을 준다.
    [menu alignItemsVerticallyWithPadding:20];
    //메뉴의 위치를 지정한다.
    [menu setPosition:ccp( size.width/2, 100)];
    //메뉴를 자식으로 추가한다.
    [self addChild:menu];
  }
  return self;
}

@end
