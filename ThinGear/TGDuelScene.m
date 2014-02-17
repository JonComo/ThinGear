//
//  TGDuelScene.m
//  ThinGear
//
//  Created by Jon Como on 2/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGDuelScene.h"

#import "TGButton.h"
#import "TGCharacter.h"

#import "TGWeapon.h"
#import "TGShield.h"

@interface TGDuelScene () <SKPhysicsContactDelegate>
{
    
}

@end

@implementation TGDuelScene
{
    TGCharacter *player;
    TGCharacter *enemy;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        self.backgroundColor = [UIColor purpleColor];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, size.width, size.height)];
        
        self.physicsWorld.contactDelegate = self;
        
        SKSpriteNode *ground = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(size.width, 100)];
        ground.position = CGPointMake(size.width/2, 50);
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        ground.physicsBody.dynamic = NO;
        ground.physicsBody.friction = 1;
        ground.physicsBody.categoryBitMask = TGColliderTypeGround;
        ground.physicsBody.collisionBitMask = TGColliderTypeWeapon;
        ground.name = @"Ground";
        [self addChild:ground];
        
        player = [[TGCharacter alloc] initWithPosition:CGPointMake(size.width/2, 220) texturePrefix:@"player" scene:self];
        player.equipA = [TGWeapon sword];
        player.equipB = [TGShield shield];
        
        TGCharacter *randChar = [[TGCharacter alloc] initWithPosition:CGPointMake(arc4random()%(int)size.width, 200) texturePrefix:@"player" scene:self];
        
        randChar.equipA = [TGWeapon sword];
        randChar.equipB = [TGShield shield];
        
        randChar.target = player;
        player.target = randChar;
        
        float padding = 10;
        
        TGButton *left = [TGButton buttonWithActionBlock:^(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped) {
            player.walkLeft = wasPressed;
            if (wasDoubleTapped) [player dodgeInDirection:TGDirectionLeft];
        }];
        
        left.position = CGPointMake(left.size.width/2 + padding, left.size.height/2 + padding);
        [self addChild:left];
        
        TGButton *right = [TGButton buttonWithActionBlock:^(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped) {
            player.walkRight = wasPressed;
            if (wasDoubleTapped) [player dodgeInDirection:TGDirectionRight];
        }];
        
        right.position = CGPointMake(left.position.x + right.size.width + padding, right.size.height/2 + padding);
        [self addChild:right];
        
        TGButton *triggerA = [TGButton buttonWithActionBlock:^(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped) {
            if (wasPressed)
                [player.equipA triggerWithStrength:TGStrengthWeak];
            if (wasReleased)
                [player.equipA releaseTrigger];
        }];
        triggerA.position = CGPointMake(size.width - (triggerA.size.width/2 + padding), triggerA.size.height/2 + padding);
        [self addChild:triggerA];
        
        TGButton *triggerB = [TGButton buttonWithActionBlock:^(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped) {
            if (wasPressed)
                [player.equipB triggerWithStrength:TGStrengthWeak];
            if (wasReleased)
                [player.equipB releaseTrigger];
        }];
        triggerB.position = CGPointMake(triggerA.position.x - triggerB.size.width - padding, triggerB.size.height/2 + padding);
        [self addChild:triggerB];
    }
    
    return self;
}

-(void)update:(NSTimeInterval)currentTime
{
    for (SKSpriteNode *node in self.children)
    {
        if ([node isKindOfClass:[TGCharacter class]]){
            [(TGCharacter *)node update:currentTime];
            
            if (arc4random()%30==0 && node != player){
                [(TGCharacter *)node dodgeInDirection:arc4random()%2 ? TGDirectionRight : TGDirectionLeft];
            }
        }
    }
}

-(void)didSimulatePhysics
{
    for (SKSpriteNode *node in self.children)
    {
        if ([node isKindOfClass:[TGCharacter class]]){
            [(TGCharacter *)node didSimulatePhysics];
        }
    }
}

#pragma SKPhysicsContactDelegate

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    TGSprite *spriteA = (TGSprite *)contact.bodyA.node;
    TGSprite *spriteB = (TGSprite *)contact.bodyB.node;
    
    if ([spriteA isKindOfClass:[TGSprite class]])
        [spriteA didBeginContact:contact withSprite:spriteB];
    
    if ([spriteB isKindOfClass:[TGSprite class]])
        [spriteB didBeginContact:contact withSprite:spriteA];
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    TGSprite *spriteA = (TGSprite *)contact.bodyA.node;
    TGSprite *spriteB = (TGSprite *)contact.bodyB.node;
    
    if ([spriteA isKindOfClass:[TGSprite class]])
        [spriteA didEndContact:contact];
    
    if ([spriteB isKindOfClass:[TGSprite class]])
        [spriteB didEndContact:contact];
}

@end