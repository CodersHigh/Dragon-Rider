//
//  GameLayer.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright 2013 Appilogue. All rights reserved.
//

#import "GameLayer.h"
#import "Enemy.h"
#import "Bullet.h"
#import "MenuLayer.h"
#import "Dust.h"
#import "SimpleAudioEngine.h"
#import "GB2ShapeCache.h"

#import "GLES-Render.h"

@implementation GameLayer

-(id)init
{
  self = [super init];
  if (self) {
    //윈도우 화면 크기를 가져온다.
    winSize = [[CCDirector sharedDirector] winSize];
    
    //마지막 총알 번호를 위해 초기화
    lastBullet = 0;
    
    //총알을 위해 배치노드 사용
    _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"dragonRideSprite.pvr.ccz"];
    [self addChild:_batchNode];
    
    //스프라이트 프레임 케쉬에 스프라이트를 저장한다.
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dragonRideSprite.plist"];
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"collision.plist"];
    
    [self setupPhysicsWorld];
    
    //배경 초기화
    [self initBackground];
    
    //플레이어 캐릭터 초기화
    [self initPlayer];
    
    //적 초기화
    [self initEnemys];
    
    //총알 초기화
    [self initBullet];
  }
  return self;
}

-(void)initBackground{
  //배경에 사용할 1번 이미지를 생성 후, 화면에 꽉 차게 이동 시킨다.
  _backgroundImage1 = [CCSprite spriteWithFile:@"background.png"];
  _backgroundImage1.anchorPoint = CGPointZero;
  [self addChild:_backgroundImage1 z:-1];
  
  //배경에 사용할 2번 이미지를 생성 후, 1번 이미지 위로 이동 시킨다.
  _backgroundImage2 = [CCSprite spriteWithFile:@"background.png"];
  _backgroundImage2.anchorPoint = CGPointZero;
  _backgroundImage2.position = ccp(0, [_backgroundImage2 boundingBox].size.height);
  [self addChild:_backgroundImage2 z:-1];
}

#define PTM_RATIO 16

- (void)update:(ccTime)dt {
  // 배경화면 움직이는 속도, 현재 위치에 이동할 위치를 ccpAdd로 더하는 방식
  CGPoint backgroundScrollVel = ccp(0, -100);
  // 현재 이미지1의 위치 값을 불러온다.
  CGPoint currentPos = [_backgroundImage1 position];
  // 1번 이미지가 스크롤 되서 사라지고, 2번 이지미가 1번 이미지의 초기 위치에 오면 최초위치로 이동
  
  if (currentPos.y < -winSize.height) {
    [_backgroundImage1 setPosition: CGPointZero];
    currentPos = ccp(0, [_backgroundImage2 boundingBox].size.height);;
    [_backgroundImage2 setPosition: currentPos];
    //현재 위치에서 backgroundScrollVel을 더 한다.
  } else{
    _backgroundImage1.position = ccpAdd(ccpMult(backgroundScrollVel, dt), _backgroundImage1.position);
    _backgroundImage2.position = ccpAdd(ccpMult(backgroundScrollVel, dt), _backgroundImage2.position);
  }
  
  //총알과 적 캐릭터와 충돌을 체크하기 위해서 배열에서 적을 하나 꺼낸다.
  for (Enemy *enemy in enemysArray) {
    //적이 죽은 상태이면 그냥 넘어간다.
    if (!enemy.state) continue;
    
    //총알을 하나 배열에서 꺼낸다
    for (Bullet *bullet in bulletsArray) {
      //총알이 적에 맞아서 없어진 상태면 그냥 넘어간다.
      if (!bullet.visible) continue;
      
      //총알과 적이 충돌이 나는지를 체크
      if (!isCollision && CGRectIntersectsRect(bullet.boundingBox, enemy.boundingBox)){
        //총알을 없애고
        bullet.visible = NO;
        
        //사운드 효과를 재생한다.
        [[SimpleAudioEngine sharedEngine] playEffect:@"mon_damage.wav"];
        
        //미사일로 적을 공격해서 0점을 받아오는지를 체크
        if (![enemy attackedWithPoint:[bullet bulletType]]){
          
          //사운드 효과를 재생한다.
          [[SimpleAudioEngine sharedEngine] playEffect:@"mon_die.wav"];
          
          //적이 폭발하면 먼지를 뿌려주기위한 노드 생성
          Dust *dust = [Dust node];
          //위치는 적이 폭발한 위치
          dust.position = enemy.position;
          //화면에 뿌려주기 위해 자식노드로 추가
          [self addChild:dust];
          //폭발하는 애니메이션 실행
          [dust animateDusts];
        }
      }
    }
  }
  
  world->Step(dt, 0, 0);
  for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
    if (b->GetUserData() != NULL) {
      CCSprite *sprite = (__bridge CCSprite *)b->GetUserData();
      
      b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                 sprite.position.y/PTM_RATIO);
      float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
      
      b->SetTransform(b2Position, b2Angle);
    }
  }
}

- (void)initPlayer {
  //플레이어 캐릭터를 생성한다.
  _player = [Player node];
  //가장 위에 위치 시킨다.
  [self addChild:_player z:99];
  
  [_player createBox2dObject:world];
  // 픽스처 정의를 body에 추가하기
  [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_player.body forShapeName:@"player"];
}

#define kMaxMonster 5 //기본 적의 수

- (void)initEnemys {
  //적을 저장할 배열을 생성한다.
  enemysArray = [[CCArray alloc] initWithCapacity:kMaxMonster];
  //화면을 균등하게 나눈다.
  float width = winSize.width / kMaxMonster;
  
  //적의 최대 갯수 만큼 화면에 나타내고, 배열에 저장
  for ( int i = 0; i < kMaxMonster ; i++ ) {
    //적 노드를 생성.
    Enemy *enemy = [Enemy node];
    //화면에 위치 시킨다.
    [self addChild:enemy z:98];
    //균등하게 나눈 화면에서 가운데에 위치 시킨다.
    enemy.position = ccp( i * width + width / 2, winSize.height + enemy.boundingBox.size.height / 2);
    //그리고 나중에 충돌 등을 위해 배열에 넣는다.
    [enemysArray addObject:enemy];
    
    [enemy createBox2dObject:world];
    // 픽스처 정의를 body에 추가하기
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:enemy.body forShapeName:@"dragon_01_body"];
  }
}

#define kMaxBullet 30

-(void)initBullet {
  //총알 갯수의 크기로 배열을 만든다.
  bulletsArray = [[CCArray alloc] initWithCapacity:kMaxBullet];
  //총알 갯수만큼 배열에 넣는다.
  for (int i = 0; i < kMaxBullet; i++) {
    //총알 노드를 생성
    Bullet *bullet = [Bullet node];
    //처음에는 안 보이는 상태로 만든다.
    bullet.visible = NO;
    //총알의 위치는 플레이어 캐릭터의 앞에 위치.
    bullet.position = ccp(_player.position.x, _player.position.y + _player.boundingBox.size.height / 2);
    //배치노드에 넣는다.
    [_batchNode addChild:bullet z:99];
    //충돌 등 계산을 쉽게 하기 위해 배열에 넣는다.
    [bulletsArray addObject:bullet];
  }
}

- (void)onEnter {
  [super onEnter];
  //배경 움직임을 위한 메인 스케쥴
  [self scheduleUpdate];
  //터치 이벤트를 받는다.
  [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
  //총알을 위한 스케쥴
  [self schedule:@selector(updateBullet:) interval:0.05f];
  //점수를 위한 스케쥴
  [self schedule:@selector(updateScore:) interval:0.01f];
  //시작 되면 배경 음악이 재생
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background_music.mp3" loop:YES];
}

#pragma mark Touch

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  //터치가 시작되면 이전 값과 비교를 위해 저장한다. UI좌표계를 cocos 좌표계로 변환
  previousPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
  return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  // 이전 값과 비교를 위한 움직였을때 위치 값. UI좌표계를 cocos 좌표계로 변환
  CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
  //플레이어 캐릭터의 위치를 계산한다. ( 기존 위치 X축 값 - 움직인 거리 ), Y축 값은 동일
  _player.position = ccp( _player.position.x - (previousPoint.x - location.x) * 2, _player.position.y );
  //왼쪽이나 오른쪽으로 벗어나면 넘어가지 않도록 고정 시킨다.
  if (_player.position.x < 0) {
    _player.position = ccp(0, _player.position.y);
  } else if (_player.position.x > winSize.width) {
    _player.position = ccp(winSize.width, _player.position.y);
  }
  //현재 위치를 이전 값으로 저장한다.
  previousPoint = location;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  //터치가 끝났을때는 특별한 이벤트가 없다.
}

-(void)updateBullet:(ccTime)dt {
  //배열에서 하나씩 총알을 꺼낸다.
  Bullet *bullet = (Bullet*)[bulletsArray objectAtIndex:lastBullet];
  //움직일때는 보이게 설정
  bullet.visible = YES;
  //총알의 위치는 플레이어 캐릭터의 앞에 위치.
  bullet.position = ccp(_player.position.x, _player.position.y + _player.boundingBox.size.height / 2);
  //마지막 총알이 배열의 마지막이면 다시 초기화 한다.
  if (++lastBullet == kMaxBullet) {
    lastBullet = 0;
  }
}

-(void)updateScore:(ccTime)dt{
  //일정 시간마다 점수를 올려준다.
  [_hud setScoreText:score++];
}

-(void) setupPhysicsWorld {
  b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
  
  world = new b2World(gravity);
  
//  b2Draw *debugDraw = new GLESDebugDraw(PTM_RATIO);
//  debugDraw->SetFlags(GLESDebugDraw::e_shapeBit);
//  world->SetDebugDraw(debugDraw);
//  world->DrawDebugData();
  
  contactListener = new MyContactListener();
  world->SetContactListener(contactListener);
}

- (void)collisionPlayerWithEnemy{
  //적과 플레이어 캐릭터가 충돌하는지를 체크
  //  if (!isCollision && CGRectIntersectsRect(enemy.boundingBox, _player.boundingBox)) {
  isCollision = YES;
  
  if (isCollision){
    
    //사운드 효과를 재생한다.
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
    
    // 플레이어 캐릭터가 죽을 때 폭발 효과음 재생
    _player.visible = NO;
    // 충돌하게되면 총알을 다 없앤다.
    [self unschedule:@selector(updateBullet)];
    for (Bullet *bullet in bulletsArray) {
      bullet.visible = NO;
      [bullet removeFromParentAndCleanup:YES];
    }
    
    // 충돌하게되면 점수 업데이트를 멈춘다.
    [self unschedule:@selector(updateScore:)];
    
    //적이 폭발되면 먼지를 뿌려주기위한 노드 생성
    Dust *dust = [Dust node];
    //위치는 적이 폭발된 위치
    dust.position = _player.position;
    //화면에 뿌려주기 위해 자식노드로 추가
    [self addChild:dust z:1000];
    //폭발하는 애니메이션 실행
    [dust animateExplosions];
    
    CCCallBlock *allStop = [CCCallBlock actionWithBlock:^{
      //터치 이벤트를 더이상 받지 않는다.
      [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
      
      // 배경음악을 멈춘다.
      [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }];
    
    //딜레이를 위한 엑션
    CCDelayTime *delay = [CCDelayTime actionWithDuration:2.0f];
    //딜레이후 메뉴로 나가기 위한 엑션 블럭
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
      //메뉴 레이어로 돌아간다.
      [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
    }];
    //엑션을 순서대로 준비.
    CCSequence *seq = [CCSequence actions:allStop, delay, block, nil];
    //엑션 실행
    [self runAction:seq];
  }
  //}
}

//-(void) draw
//{
//	//
//	// IMPORTANT:
//	// This is only for debug purposes
//	// It is recommend to disable it
//	//
//	[super draw];
//	
//	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
//	
//	kmGLPushMatrix();
//	
//	world->DrawDebugData();
//	
//	kmGLPopMatrix();
//}

@end
