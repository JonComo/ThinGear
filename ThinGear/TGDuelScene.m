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
        
        SKSpriteNode *ground = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(size.width, 100)];
        ground.position = CGPointMake(size.width/2, 50);
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        ground.physicsBody.dynamic = NO;
        ground.physicsBody.friction = 1;
        [self addChild:ground];
        
        player = [[TGCharacter alloc] initWithTexturePrefix:@"player"];
        player.position = CGPointMake(size.width/2, 300);
        [self addChild:player];
        
        enemy = [[TGCharacter alloc] initWithTexturePrefix:@"player"];
        enemy.position = CGPointMake(100, 300);
        [self addChild:enemy];
        
        player.target = enemy;
        enemy.target = player;
        
        /*
        SKSpriteNode *wheel = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(40, 40)];
        wheel.position = CGPointMake(player.position.x, player.position.y - player.size.height/2 + wheel.size.height*1/4);
        wheel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:wheel.size.width/2];
        wheel.physicsBody.angularDamping = 0.8;
        [self addChild:wheel];
        
        SKPhysicsJointPin *pin = [SKPhysicsJointPin jointWithBodyA:player.physicsBody bodyB:wheel.physicsBody anchor:wheel.position];
        [self.physicsWorld addJoint:pin]; */
        
        
        TGButton *left = [TGButton buttonWithActionBlock:^(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped) {
            player.walkLeft = wasPressed;
            if (wasDoubleTapped) [player dodgeInDirection:TGDirectionLeft];
        }];
        
        left.position = CGPointMake(65, 65);
        [self addChild:left];
        
        TGButton *right = [TGButton buttonWithActionBlock:^(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped) {
            player.walkRight = wasPressed;
            if (wasDoubleTapped) [player dodgeInDirection:TGDirectionRight];
        }];
        
        right.position = CGPointMake(left.position.x + 110, 65);
        [self addChild:right];
    }
    
    return self;
}

-(void)update:(NSTimeInterval)currentTime
{
    [player update:currentTime];
    [enemy update:currentTime];
    
    if (arc4random()%20==0)
    {
        [enemy dodgeInDirection:arc4random()%2 ? TGDirectionRight : TGDirectionLeft];
    }
}

@end