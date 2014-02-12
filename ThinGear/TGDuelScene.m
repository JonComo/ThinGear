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

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        self.backgroundColor = [UIColor yellowColor];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, size.width, size.height)];
        
        SKSpriteNode *ground = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(size.width, 40)];
        ground.position = CGPointMake(size.width/2, 20);
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        ground.physicsBody.dynamic = NO;
        [self addChild:ground];
        
        TGCharacter *character = [[TGCharacter alloc] initWithColor:[UIColor redColor] size:CGSizeMake(40, 80)];
        character.position = CGPointMake(size.width/2, size.height/2);
        character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
        character.physicsBody.mass = 0.2;
        character.physicsBody.allowsRotation = NO;
        [self addChild:character];
        
        SKSpriteNode *wheel = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(40, 40)];
        wheel.position = CGPointMake(character.position.x, character.position.y - character.size.height/2 + wheel.size.height*1/4);
        wheel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:wheel.size.width/2];
        [self addChild:wheel];
        
        SKPhysicsJointPin *pin = [SKPhysicsJointPin jointWithBodyA:character.physicsBody bodyB:wheel.physicsBody anchor:wheel.position];
        [self.physicsWorld addJoint:pin];
        
        
        TGButton *left = [TGButton buttonWithActionBlock:^(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped) {
            if (wasPressed){
                [character.physicsBody applyImpulse:CGVectorMake(-10, 0)];
            }
            
            if(wasDoubleTapped){
                [character.physicsBody applyImpulse:CGVectorMake(-30, 0)];
            }
        }];
        
        left.position = CGPointMake(100, 100);
        [self addChild:left];
    }
    
    return self;
}

-(void)update:(NSTimeInterval)currentTime
{
    
}

@end