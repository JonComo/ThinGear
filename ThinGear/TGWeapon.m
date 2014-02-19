//
//  TGWeapon.m
//  ThinGear
//
//  Created by Jon Como on 2/16/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGWeapon.h"

#import "TGCharacter.h"
#import "TGAction.h"
#import "TGDepths.h"

@implementation TGWeapon

+(TGWeapon *)sword
{
    TGWeapon *sword = [[TGWeapon alloc] initWithTexture:[SKTexture textureWithImageNamed:@"sword.png"]];
    sword.name = @"Sword";
    sword.zPosition = TGDepthWeapon;
    
    return sword;
}

-(void)triggerWithStrength:(TGStrength)strength
{
    if (self.isTriggered) return;
    self.isTriggered = YES;
    
    SKAction *animation;
    
    BOOL facingRight = self.character.facing == TGDirectionRight;
    
    if (strength == TGStrengthWeak)
    {
        [self.spriteAnimated removeAllActions];
        
        float offset = facingRight ? 60 : -60;
        
        SKAction *windUp = [SKAction moveBy:CGVectorMake(-offset/3, 0) duration:0.1];
        SKAction *swingOut = [SKAction moveBy:CGVectorMake(offset, 0) duration:0.15];
        SKAction *reset = [SKAction moveTo:CGPointZero duration:0.2];
        
        animation = [SKAction sequence:@[windUp, [SKAction runBlock:^{ self.isCollidable = YES; }], swingOut, [SKAction runBlock:^{ self.isCollidable = NO; }], reset, [SKAction runBlock:^{ self.isTriggered = NO; }]]];
    }else{
        //Strong attack
        [self.spriteAnimated removeAllActions];
        
        float angle = facingRight ? M_PI_2 : -M_PI_2;
        
        SKAction *rotate = [SKAction rotateToAngle:angle duration:0.6];
        SKAction *swing = [SKAction rotateToAngle:0 duration:0.2];
        SKAction *reset = [SKAction moveTo:CGPointZero duration:0.3];
        
        animation = [SKAction sequence:@[rotate, [SKAction runBlock:^{ self.isCollidable = YES; }], swing, [SKAction runBlock:^{ self.isCollidable = NO; }], reset, [SKAction runBlock:^{ self.isTriggered = NO; }]]];
    }
    
    [self.spriteAnimated runAction:animation];
}

-(void)didBeginContact:(SKPhysicsContact *)contact withSprite:(TGSprite *)sprite
{
    if (!self.isCollidable) return;
    if (self.isResetting) return;
    self.isResetting = YES;
    
    [self.spriteAnimated removeAllActions];
    
    self.isCollidable = NO;
    
    SKAction *resetSequence = [SKAction sequence:@[[SKAction waitForDuration:0.2], [SKAction group:@[[SKAction moveTo:CGPointZero duration:0.2], [SKAction rotateToAngle:0 duration:0.2]]], [SKAction runBlock:^{
        self.isResetting = NO;
        self.isTriggered = NO;
    }]]];
    
    [self.spriteAnimated runAction:resetSequence];
}

@end