//
//  MyContactListener.mm
//  DragonRider
//
//  Created by Steve Yeom on 6/27/13.
//  Copyright (c) 2013 Appilogue. All rights reserved.
//

#import "MyContactListener.h"
#import "Player.h"
#import "Enemy.h"
#import "CCSprite.h"
#import "GameLayer.h"

MyContactListener::MyContactListener() : _contacts() {
}

MyContactListener::~MyContactListener() {
}

void MyContactListener::BeginContact(b2Contact* contact) {
  // We need to copy out the data because the b2Contact passed in
  // is reused.
  MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
  _contacts.push_back(myContact);
  
  b2Body* bodyA = contact->GetFixtureA()->GetBody();
  b2Body* bodyB = contact->GetFixtureB()->GetBody();
  
  if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
  {
    CCSprite* bNodeA = (__bridge CCSprite*)bodyA->GetUserData();
    CCSprite* bNodeB = (__bridge CCSprite*)bodyB->GetUserData();
    
    Player *player;
    Enemy *enemy;
    
    if ([bNodeA isKindOfClass:[Player class]]) {
      player = (Player *)bNodeA;
      enemy = (Enemy *)bNodeB;
    } else {
      enemy = (Enemy*)bNodeA;
      player = (Player *)bNodeB;
    }
    
    if (player.visible == YES && enemy.visible == YES){
      [(GameLayer *)[player parent] collisionPlayerWithEnemy];
    }
  }
}

void MyContactListener::EndContact(b2Contact* contact) {
  MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
  std::vector<MyContact>::iterator pos;
  pos = std::find(_contacts.begin(), _contacts.end(), myContact);
  if (pos != _contacts.end()) {
    _contacts.erase(pos);
  }
}

void MyContactListener::PreSolve(b2Contact* contact,
                                 const b2Manifold* oldManifold) {
}

void MyContactListener::PostSolve(b2Contact* contact,
                                  const b2ContactImpulse* impulse) {
}