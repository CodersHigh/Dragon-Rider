//
//  HighScore.m
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright (c) 2013 Appilogue. All rights reserved.
//

#import "HighScore.h"

@implementation HighScore

//파일 패스를 불러온다.
-(NSString *)filePath{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];
  NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"HighScoreData"];
  return filePath;
}

-(void)loadHighScores{
  NSString *filePath = [self filePath];
  
  //파일이 있으면 파일로 부터 값을 배열에 저장
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
    self.scoresArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
  } else{
    //없으면 새로운 값 10개를 배열로 생성.
    self.scoresArray = [[NSMutableArray alloc] initWithObjects:
                        @"Steve Jobs:1",
                        @"krazyeom:1",
                        @"Steve:1",
                        @"huddlebooks:1",
                        @"cocos2d:1",
                        @"sungwook:1",
                        @"golbin:1",
                        @"lingostar:1",
                        @"hello world:1",
                        @"sprite kit:1",nil];
  }
}

-(void)saveHighScores{
  if (_scoresArray == nil) return;
  
  //점수 배열을 파일 패스에 파일로 저장한다.
  NSString *filePath = [self filePath];
  [_scoresArray writeToFile:filePath atomically:YES];
}

-(void)saveNewRecordWithName:(NSString *)name score:(NSInteger)newScore{
  if ([self isHighScore:newScore] == NO) return;
  
  //배열에서 순차적으로 새로운 점수와 비교한다.
  for (NSInteger i = 0; i < 10; i++) {
    NSString *record = [self.scoresArray objectAtIndex:i];
    NSString *scoreString = [self scoreFromRecord:record];
    
    if (scoreString == nil) {
      continue;
    }
    
    NSInteger thisScore = [scoreString integerValue];
    
    //기존 점수보다 새로운 점수가 크면 배열 사이에 넣고 마지막 배열 삭제
    if (newScore > thisScore){
      NSString *newRecord = [NSString stringWithFormat:@"%@:%d", name, newScore];
      [_scoresArray insertObject:newRecord atIndex:i];
      [_scoresArray removeLastObject];
      break;
    }
  }
  [self saveHighScores];
}

-(BOOL)isHighScore:(NSInteger)newScore{
  NSInteger worstScore = 0;
  //점수 배열에 값이 없으면 점수를 불러온다.
  if (self.scoresArray == nil || [self.scoresArray count] < 1) [self loadHighScores];
  
  //10위 레코드 값을 가져온다.
  NSString *worstRecord = (NSString *) [self.scoresArray lastObject];
  //레코드 값에서 점수를 가져온다.
  NSString *scoreString = [self scoreFromRecord:worstRecord];
  if (scoreString != nil) worstScore = [scoreString integerValue];
  
  //새로운 점수가 기존 점수 보다 높은지 판단.
  if (newScore > worstScore)  return YES;
  
  return NO;
}

-(NSString *)scoreFromRecord:(NSString *)record{
  if (record == nil) return 0;
  
  //11. : 문자를 기준으로 뒤의 값을 점수로 가져온다.
  NSRange nameRange = [record rangeOfString:@":"];
  if (nameRange.location != NSNotFound) {
    return [record substringFromIndex:nameRange.location + 1];
  } else {
    return nil;
  }
}

-(NSString*)nameFromRecord:(NSString *)record{
  if (record == nil) return 0;
  
  //12. : 문자를 기준으로 뒤의 값을 이름으로 가져온다.
  NSRange nameRange = [record rangeOfString:@":"];
  if (nameRange.location != NSNotFound) {
    return [record substringToIndex:nameRange.location];
  } else {
    return nil;
  }
}

@end
