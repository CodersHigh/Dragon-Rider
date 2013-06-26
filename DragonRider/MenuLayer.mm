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
    
    //제목으로 만들 레이블을 시스템 폰트를 사용해서 만든다.
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Dragon Rider" fontName:@"HelveticaNeue" fontSize:36];
    //레이블의 위치를 지정한다.
    label.position = ccp( size.width/2, size.height/2 + 100 );
    //레이블을 자식으로 추가한다.
    [self addChild:label];
    
    CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Made by @krazyeom" fontName:@"HelveticaNeue" fontSize:30];
    //레이블의 위치를 지정한다.
    label2.position = ccp( size.width/2, size.height/2 + 60 );
    //레이블을 자식으로 추가한다.
    [self addChild:label2];
    
    //메뉴 아이템의 폰트를 변경한다.
    [CCMenuItemFont setFontName:@"AppleSDGothicNeo-Medium"];
    //메뉴 아이템 블럭
    CCMenuItem *startItem = [CCMenuItemFont itemWithString:@"Start" block:^(id sender)  {
      //Start 메뉴 버튼이 눌렸을 경우, GameScene을 화면 전환과 함께 호출한다.
      [[CCDirector sharedDirector] replaceScene:[GameScene node]];
    }];
    
    //메뉴 버튼을 메뉴에 추가한다.
    CCMenu *menu = [CCMenu menuWithItems:startItem, nil];
    //세로 정렬로 각 메뉴의 사잇값으로 20을 준다.
    [menu alignItemsVerticallyWithPadding:20];
    //메뉴의 위치를 지정한다.
    [menu setPosition:ccp( size.width/2, size.height/2 - 50)];
    //메뉴를 자식으로 추가한다.
    [self addChild:menu];
  }
  return self;
}

@end
