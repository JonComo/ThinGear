//
//  TGSprite.h
//  ThinGear
//
//  Created by Jon Como on 2/16/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TGSprite : SKSpriteNode

-(void)update:(NSTimeInterval)currentTime;
-(void)didSimulatePhysics;

-(void)playCollisionSound;

-(void)didBeginContact:(SKPhysicsContact *)contact withSprite:(TGSprite *)sprite;
-(void)didEndContact:(SKPhysicsContact *)contact;

@end