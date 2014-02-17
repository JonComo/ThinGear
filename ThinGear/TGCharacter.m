//
//  TGCharacter.m
//  ThinGear
//
//  Created by Jon Como on 2/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGCharacter.h"

#import "TGDepths.h"

@implementation TGCharacter
{
    BOOL isDodging;
}

-(id)initWithPosition:(CGPoint)position texturePrefix:(NSString *)texPrefix scene:(SKScene *)scene
{
    SKTexture *texture = [SKTexture textureWithImageNamed:texPrefix]; //idle
    
    if (self = [super initWithColor:[UIColor clearColor] size:texture.size]) {
        //init
        [scene addChild:self];
        self.position = position;
        
        _texturePrefix = texPrefix;
        _graphics = [[SKSpriteNode alloc] initWithTexture:texture];
        [self addChild:_graphics];
        
        self.speed = 300;
        _facing = TGDirectionRight;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:texture.size];
        self.physicsBody.mass = 0.1;
        self.physicsBody.friction = 0.4;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.categoryBitMask = TGColliderTypeCharacter;
        self.physicsBody.collisionBitMask = TGColliderTypeGround | TGColliderTypeCharacter | TGColliderTypeWeapon;
        
        self.zPosition = TGDepthCharacter;
    }
    
    return self;
}

-(void)setEquipA:(TGEquip *)equipA
{
    _equipA = equipA;
    
    equipA.centerOffset = CGPointMake(20, 0);
    
    [self equipItem:equipA];
}

-(void)setEquipB:(TGEquip *)equipB
{
    _equipB = equipB;
    
    equipB.centerOffset = CGPointMake(-14, 0);
    
    [self equipItem:equipB];
}

-(void)equipItem:(TGEquip *)item
{
    item.position = self.position;
    
    item.character = self;
    [self.scene addChild:item];
    
    SKPhysicsJointLimit *limit = [SKPhysicsJointLimit jointWithBodyA:self.physicsBody bodyB:item.physicsBody anchorA:self.position anchorB:item.position];
    limit.maxLength = 200;
    [self.scene.physicsWorld addJoint:limit];
}

-(void)setFacing:(TGDirection)facing
{
    if (_facing != facing){
        _facing = facing;
        self.graphics.xScale = facing == TGDirectionRight ? 1.0 : -1.0;
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    [self.equipA update:currentTime];
    [self.equipB update:currentTime];
    
    float speed = self.speed;
    
    if (self.equipA.isTriggered)
        speed *= 0.4;
    if (self.equipB.isTriggered)
        speed *= 0.4;
    
    if (!isDodging){
        if (self.walkLeft){
            self.physicsBody.velocity = CGVectorMake((self.facing == TGDirectionLeft) ? -speed : -speed*0.65, self.physicsBody.velocity.dy);
        }else if(self.walkRight){
            self.physicsBody.velocity = CGVectorMake((self.facing == TGDirectionRight) ? speed : speed*0.65, self.physicsBody.velocity.dy);
        }
        
        if (!self.equipA.isTriggered && !self.equipB.isTriggered)
            [self faceTarget];
    }
}

-(void)didSimulatePhysics
{
    [self.equipA didSimulatePhysics];
    [self.equipB didSimulatePhysics];
}

-(void)faceTarget
{
    if (self.position.x < self.target.position.x){
        self.facing = TGDirectionRight;
    }else{
        self.facing = TGDirectionLeft;
    }
}

-(void)dodgeInDirection:(TGDirection)direction
{
    if (isDodging) return;
    isDodging = YES;
    
    float rollDirection = self.speed * 0.12;
    
    if (direction == TGDirectionLeft) rollDirection *= -1;
    
    SKAction *dodge;
    
    if (direction == self.facing){
        SKTexture *currentTexture = self.graphics.texture;
        
        SKAction *rotate = [SKAction rotateByAngle:(direction == TGDirectionRight ? -2*M_PI : 2*M_PI) duration:.6];
        rotate.timingMode = SKActionTimingEaseOut;
        
        dodge = [SKAction sequence:@[[SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Roll", self.texturePrefix]]], rotate, [SKAction setTexture:currentTexture], [SKAction runBlock:^{ isDodging = NO; }]]];
        
        [self.physicsBody applyImpulse:CGVectorMake(rollDirection, 50)];
        
        [self.equipA.graphics runAction:rotate];
        [self.equipB.graphics runAction:rotate];
    }else{
        //Backstep
        dodge = [SKAction sequence:@[[SKAction waitForDuration:.4], [SKAction runBlock:^{
            isDodging = NO;
        }]]];
        
        [self.physicsBody applyImpulse:CGVectorMake(rollDirection, 18)];
    }
    
    [self.graphics runAction:dodge];
}

@end