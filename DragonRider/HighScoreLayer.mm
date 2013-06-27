//
//  HighScoreLayer.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "HighScoreLayer.h"
#import "HighScore.h"
#import "MenuLayer.h"

@implementation HighScoreLayer

+ (CCScene*)scene{
  //씬을 만들고 레이어를 자식으로 추가하여 반환
  CCScene *scene = [CCScene node];
  HighScoreLayer *layer = [HighScoreLayer node];
  [scene addChild:layer];
  
  return scene;
  
}

- (id)init {
  self = [super init];
  if (self) {
    //배경화면을 하얀색으로 설정
    [self addChild:[CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)]];
    //화면에 점수를 보여준다
    [self displayScore];
  }
  return self;
}

- (void)displayScore{
  //점수를 파일로 부터 불러온다.
  HighScore *highscore = [HighScore new];
  [highscore loadHighScores];
  
  NSArray *scoreArray = [highscore scoresArray];
  
  CGFloat startYPosition = 450;
  
  CGSize size = [[CCDirector sharedDirector] winSize];
  
  //배열에서 이름과 점수를 불러서 화면에 표시한다.
  for (NSInteger i = 0; i < [scoreArray count]; i++) {
    NSString *record = [scoreArray objectAtIndex:i];
    
    NSString *name = [highscore nameFromRecord:record];
    NSString *score = [highscore scoreFromRecord:record];
    
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"High Score!" fntFile:@"font.fnt"];
    label.position = CGPointMake(size.width / 2, size.height - 50);
    [self addChild:label];
    
    CCLabelBMFont *nameLabel = [CCLabelBMFont labelWithString:name fntFile:@"font.fnt"];
    nameLabel.anchorPoint = CGPointMake(0, 1);
    nameLabel.position = CGPointMake(20, startYPosition - 30 * i);
    [self addChild:nameLabel];
    
    CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:score fntFile:@"font.fnt"];
    scoreLabel.anchorPoint = CGPointMake(0, 1);
    scoreLabel.position = CGPointMake(250, startYPosition - 30 * i);
    [self addChild:scoreLabel];
    
    //종료 메뉴
    CCLabelBMFont *exit = [CCLabelBMFont labelWithString:@"EXIT" fntFile:@"font.fnt"];
    CCMenuItem *item = [CCMenuItemLabel itemWithLabel:exit target:self selector:@selector(exit)];
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    [menu alignItemsVertically];
    menu.position = ccp(size.width / 2, 50);
    [self addChild:menu];
  }
}

- (void)exit{
  //종료 버튼이 눌리면 메뉴 화면으로 돌아간다
  CCScene *scene = [MenuLayer scene];
  if ([[CCDirector sharedDirector] runningScene] == nil){
    [[CCDirector sharedDirector] runWithScene:scene];
  }else{
    [[CCDirector sharedDirector] replaceScene:scene];
  }
}

@end
