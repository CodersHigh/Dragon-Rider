//
//  HighScoreInputViewController.m
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright (c) 2013 Appilogue. All rights reserved.
//

#import "HighScoreInputViewController.h"
#import "AppDelegate.h"
#import "HighScore.h"
#import "HighScoreLayer.h"

@interface HighScoreInputViewController ()

@end

@implementation HighScoreInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 50)];
    label.text = @"New High Score!!!";
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    
    UILabel *highScore = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 150, 30)];
    highScore.text = @"Enter your name";
    [self.view addSubview:highScore];
    
    //사용자 이름을 입력 받을 수 있는 TextField 생성
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(150, 50, 150, 30)];
    _userName.keyboardType = UIKeyboardTypeASCIICapable;
    _userName.font = [UIFont systemFontOfSize:14];
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.borderStyle = UITextBorderStyleBezel;
    _userName.delegate = self;
    //키보드 호출
    [_userName becomeFirstResponder];
    [self.view addSubview:_userName];
    
    self.view.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

//리턴키가 눌리면 호출이 되고, HighScoreLayer 씬을 보여준다.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  HighScore *score = [HighScore new];
  [score saveNewRecordWithName:_userName.text score:_gamePoint];
  
  [self.navigationController popViewControllerAnimated:YES];
  [[CCDirector sharedDirector] replaceScene:[HighScoreLayer scene]];
  
  return YES;
}

#define MAXLENGTH 10

//최대입력할 수 있는 자리수 범위가 넘어가면 입력이 정지된다.
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSUInteger oldLength = [textField.text length];
  NSUInteger replacementLength = [string length];
  NSUInteger rangeLength = range.length;
  
  NSUInteger newLength = oldLength - rangeLength + replacementLength;
  
  BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
  
  return newLength <= MAXLENGTH || returnKey;
}
@end
