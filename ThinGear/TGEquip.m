//
//  TGEquip.m
//  ThinGear
//
//  Created by Jon Como on 2/16/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGEquip.h"

#import "TGCharacter.h"

@implementation TGEquip

-(instancetype)initWithTexture:(SKTexture *)texture
{
    _graphics = [[SKSpriteNode alloc] initWithTexture:texture];
    
    if (self = [super initWithColor:[UIColor clearColor] size:texture.size]) {
        //init
        [self addChild:_graphics];
    }
    
    return self;
}

-(void)setCharacter:(TGCharacter *)character
{
    _character = character;
    
    self.position = CGPointMake(character.position.x + self.centerOffset.x, self.character.position.y + self.centerOffset.y);
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.mass = 0.1;
    self.physicsBody.categoryBitMask = TGColliderTypeWeapon;
    self.physicsBody.contactTestBitMask = TGColliderTypeCharacter;
    self.physicsBody.dynamic = NO;
    
    if (!self.spriteAnimated){
        self.spriteAnimated = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(4, 4)];
        [self addChild:self.spriteAnimated];
    }
}

-(void)didSimulatePhysics
{
    BOOL faceRight = self.character.facing == TGDirectionRight;
    
    self.position = CGPointMake(self.character.position.x + self.spriteAnimated.position.x + (faceRight ? self.centerOffset.x : -self.centerOffset.x), self.character.position.y + self.spriteAnimated.position.y + self.centerOffset.y);
    self.zRotation = self.spriteAnimated.zRotation;
    
    self.graphics.xScale = faceRight ? 1 : -1;
}

-(void)triggerWithStrength:(TGStrength)strength
{
    
}

-(void)releaseTrigger
{
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact withSprite:(SKSpriteNode *)sprite
{
    
}

@end