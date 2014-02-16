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
        [self addChild:ground];
        
        player = [[TGCharacter alloc] initWithPosition:CGPointMake(size.width/2, 220) texturePrefix:@"player" scene:self];
        //[self addChild:player];
        
        
        for (int i = 0; i<2; i++) {
            TGCharacter *randChar = [[TGCharacter alloc] initWithPosition:CGPointMake(arc4random()%(int)size.width, 200) texturePrefix:@"player" scene:self];
            //[self addChild:randChar];
            randChar.target = player;
        }
        
        /*
        enemy = [[TGCharacter alloc] initWithTexturePrefix:@"player"];
        enemy.position = CGPointMake(100, 300);
        [self addChild:enemy];
        
        player.target = enemy;
        enemy.target = player; */
        
        /*
        SKSpriteNode *wheel = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(40, 40)];
        wheel.position = CGPointMake(player.position.x, player.position.y - player.size.height/2 + wheel.size.height*1/4);
        wheel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:wheel.size.width/2];
        wheel.physicsBody.angularDamping = 0.8;
        [self addChild:wheel];
        
        SKPhysicsJointPin *pin = [SKPhysicsJointPin jointWithBodyA:player.physicsBody bodyB:wheel.physicsBody anchor:wheel.position];
        [self.physicsWorld addJoint:pin]; */
        
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
        
        TGButton *attack = [TGButton buttonWithActionBlock:^(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped) {
            [player attackWithType:(wasPressed && !wasDoubleTapped) ? TGAttackTypeWeak : TGAttackTypeStrong];
        }];
        attack.position = CGPointMake(size.width - (attack.size.width/2 + padding), attack.size.height/2 + padding);
        [self addChild:attack];
    }
    
    return self;
}

-(void)update:(NSTimeInterval)currentTime
{
    for (SKSpriteNode *node in self.children)
    {
        if ([node isKindOfClass:[TGCharacter class]]){
            [(TGCharacter *)node update:currentTime];
            
            if (arc4random()%80==0 && node != player){
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
    SKSpriteNode *spriteA = (SKSpriteNode *)contact.bodyA.node;
    if ([spriteA isKindOfClass:[SKSpriteNode class]])
    {
    spriteA.colorBlendFactor = 1;
    spriteA.color = [UIColor redColor];
    }
    
//    SKSpriteNode *spriteB = (SKSpriteNode *)contact.bodyB.node;
//    if ([spriteB isKindOfClass:[SKSpriteNode class]])
//    {
//    spriteB.colorBlendFactor = 1;
//    spriteB.color = [UIColor redColor];
//    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *spriteA = (SKSpriteNode *)contact.bodyA.node;
    if ([spriteA isKindOfClass:[SKSpriteNode class]])
    {
        spriteA.colorBlendFactor = 0;
        spriteA.color = [UIColor blackColor];
    }
    
//    SKSpriteNode *spriteB = (SKSpriteNode *)contact.bodyB.node;
//    if ([spriteB isKindOfClass:[SKSpriteNode class]])
//    {
//        spriteB.colorBlendFactor = 0;
//        spriteB.color = [UIColor clearColor];
//    }
}

@end