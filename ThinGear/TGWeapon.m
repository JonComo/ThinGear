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

-(void)didSimulatePhysics
{
    if (!self.isTriggered){
        if (self.character.facing == TGDirectionRight)
        {
            self.spriteAnimated.zRotation = 0.2;
        }else{
            self.spriteAnimated.zRotation = -0.2;
        }
    }
    
    [super didSimulatePhysics];
}

-(void)triggerWithStrength:(TGStrength)strength
{
    if (self.isTriggered) return;
    self.isTriggered = YES;
    
    float offset = self.character.facing == TGDirectionRight ? 80 : -80;
    
    SKAction *windUp = [SKAction moveBy:CGVectorMake(-offset/3, 0) duration:0.2];
    SKAction *swingOut = [SKAction moveBy:CGVectorMake(offset, 0) duration:0.15];
    SKAction *reset = [SKAction moveTo:CGPointZero duration:0.2];
    
    SKAction *animation = [SKAction sequence:@[windUp, [SKAction runBlock:^{ self.isCollidable = YES; }], swingOut, [SKAction runBlock:^{ self.isCollidable = NO; }], reset, [SKAction runBlock:^{ self.isTriggered = NO; }]]];
    
    [self.spriteAnimated runAction:animation];
}

-(void)didBeginContact:(SKPhysicsContact *)contact withSprite:(SKSpriteNode *)sprite
{
    if (!self.isCollidable) return; //has to be swinging
    if (self.isResetting) return;
    
    self.isResetting = YES;
    
    [self.spriteAnimated removeAllActions];
    
    SKAction *resetSequence = [SKAction sequence:@[[TGAction bodyHitSound], [SKAction waitForDuration:0.2], [SKAction moveTo:CGPointZero duration:0.2], [SKAction runBlock:^{
        self.isResetting = NO;
        self.isCollidable = NO;
        self.isTriggered = NO;
    }]]];
    
    [self.spriteAnimated runAction:resetSequence];
}

@end
