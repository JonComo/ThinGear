//
//  TGShield.m
//  ThinGear
//
//  Created by Jon Como on 2/16/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGShield.h"

#import "TGCharacter.h"
#import "TGAction.h"
#import "TGDepths.h"

@implementation TGShield

+(TGShield *)shield
{
    TGShield *shield = [[TGShield alloc] initWithTexture:[SKTexture textureWithImageNamed:@"shield.png"]];
    shield.name = @"Shield";
    shield.zPosition = TGDepthShield;
    return shield;
}

-(void)triggerWithStrength:(TGStrength)strength
{
    if (self.isTriggered) return;
    self.isTriggered = YES;
    
    float offset = self.character.facing == TGDirectionRight ? 45 : -45;
    
    SKAction *block = [SKAction moveBy:CGVectorMake(offset, 0) duration:0.12];
    
    block.timingMode = SKActionTimingEaseOut;
    
    SKAction *animation = [SKAction sequence:@[block, [SKAction runBlock:^{ self.isCollidable = YES; }]]];
    
    [self.spriteAnimated runAction:animation];
}

-(void)releaseTrigger
{
    if (self.isResetting) return;
    self.isResetting = YES;
    
    [self.spriteAnimated removeAllActions];
    
    SKAction *resetTransform = [SKAction moveTo:CGPointZero duration:0.2];
    
    resetTransform.timingMode = SKActionTimingEaseOut;
    
    SKAction *reset = [SKAction sequence:@[resetTransform, [SKAction runBlock:^{ self.isTriggered = NO; self.isResetting = NO; self.isCollidable = NO; }]]];
    
    [self.spriteAnimated runAction:reset];
}

-(void)didBeginContact:(SKPhysicsContact *)contact withSprite:(SKSpriteNode *)sprite
{
    if (!self.isCollidable) return;
    
    [self playCollisionSound];
}

-(void)playCollisionSound
{
    [self runAction:[TGAction shieldHitSound]];
}

@end
