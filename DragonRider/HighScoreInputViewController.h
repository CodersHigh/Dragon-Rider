//
//  HighScoreInputViewController.h
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright (c) 2013 Appilogue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoreInputViewController : UIViewController <UITextFieldDelegate> //텍스트 필드 프로토콜

//게임 점수를 받는다.
@property NSInteger gamePoint;
//사용자 이름 입력을 받는다.
@property (nonatomic, strong) UITextField *userName;

@end
