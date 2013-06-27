//
//  HUDLayer.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer

- (id)init
{
  self = [super init];
  if (self) {
//    //레이블의 초기값을 0M 으로 한다. 시스템 폰트 사용
//    scoreLabel = [CCLabelTTF labelWithString:@"0M" fontName:@"Arial" fontSize:20];
    //레이블의 초기값을 0M 으로 한다. 비트맵 폰트 사용
    scoreLabel = [CCLabelBMFont labelWithString:@"0M" fntFile:@"font.fnt"];
    //위치를 정한다.
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    scoreLabel.position = ccp(280, winSize.height - 30);
    //화면에 보이기위해 자식노드에 추가
    [self addChild:scoreLabel];
  }
  return self;
}

-(void)setScoreText:(int)score{
  //점수 레이블을 위한 문자열로 변환
  NSString *scoreString = [NSString stringWithFormat:@"%dM", score];
  //레이블의 스트링에 할당한다.
  scoreLabel.string = scoreString;
}

@end
