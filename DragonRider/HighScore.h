//
//  HighScore.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright (c) 2013 Appilogue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighScore : NSObject

//점수들을 담아 놓는 배열
@property (nonatomic, strong) NSMutableArray *scoresArray;

//점수를 파일로 부터 불러온다.
-(void)loadHighScores;
//점수를 파일에 저장한다.
-(void)saveHighScores;
//이름과 점수를 저장한다.
-(void)saveNewRecordWithName:(NSString *)name score:(NSInteger)newScore;
//새로운 점수를 넣으면 점수 목록에 들어갈 수 있는지 반단
-(BOOL)isHighScore:(NSInteger)newScore;
//점수를 불러온다.
-(NSString *)scoreFromRecord:(NSString *)record;
//이름을 불러온다.
-(NSString *)nameFromRecord:(NSString *)record;

@end
