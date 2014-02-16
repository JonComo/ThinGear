//
//  TGCharacter.m
//  ThinGear
//
//  Created by Jon Como on 2/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGCharacter.h"

@implementation TGCharacter
{
    BOOL isDodging;
    SKSpriteNode *sword;
    CGPoint swordPosition;
    float swordRotation;
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
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.mass = 0.1;
        self.physicsBody.friction = 0.4;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.categoryBitMask = TGColliderTypeCharacter;
        self.physicsBody.collisionBitMask = TGColliderTypeGround | TGColliderTypeCharacter | TGColliderTypeWeapon;
        
        sword = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(8, 100)];
        sword.position = CGPointMake(position.x, position.y + self.size.height/2);
        sword.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sword.size];
        sword.physicsBody.mass = 0.1;
        sword.physicsBody.categoryBitMask = TGColliderTypeWeapon;
        sword.physicsBody.contactTestBitMask = TGColliderTypeCharacter;
        [scene addChild:sword];
        
        swordRotation = M_PI_2;
        
        /*
        swordMagnet = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(4, 4)];
        swordMagnet.position = CGPointMake(sword.position.x, sword.position.y + sword.size.height);
        swordMagnet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:swordMagnet.size];
        swordMagnet.physicsBody.mass = .3;
        [scene addChild:swordMagnet]; */
        
        SKPhysicsJointLimit *limit = [SKPhysicsJointLimit jointWithBodyA:self.physicsBody bodyB:sword.physicsBody anchorA:CGPointMake(sword.position.x, sword.position.y - sword.size.height/2) anchorB:self.position];
        limit.maxLength = 200;
        [scene.physicsWorld addJoint:limit];
        /*
        SKPhysicsJointSpring *spring = [SKPhysicsJointSpring jointWithBodyA:sword.physicsBody bodyB:swordMagnet.physicsBody anchorA:CGPointMake(sword.position.x, sword.position.y + sword.size.height/2) anchorB:swordMagnet.position];
        [scene.physicsWorld addJoint:spring]; */
    }
    
    return self;
}

-(void)setFacing:(TGDirection)facing
{
    if (_facing != facing)
    {
        _facing = facing;
        self.graphics.xScale = facing == TGDirectionRight ? 1.0 : -1.0;
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    if (!isDodging)
    {
        if (self.walkLeft){
            self.physicsBody.velocity = CGVectorMake((self.facing == TGDirectionLeft) ? -self.speed : -self.speed*0.65, self.physicsBody.velocity.dy);
        }else if(self.walkRight){
            self.physicsBody.velocity = CGVectorMake((self.facing == TGDirectionRight) ? self.speed : self.speed*0.65, self.physicsBody.velocity.dy);
        }
        
        [self faceTarget];
    }
}

-(void)didSimulatePhysics
{
    sword.zRotation = swordRotation;
    sword.position = CGPointMake(self.position.x + (self.facing == TGDirectionRight ? 10 : -10), self.position.y);
    
    /*
    swordMagnet.position = CGPointMake(self.position.x, self.position.y + 60); */
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
        
        //Roll
        SKAction *rotate = [SKAction rotateByAngle:(direction == TGDirectionRight ? -2*M_PI : 2*M_PI) duration:.6];
        rotate.timingMode = SKActionTimingEaseOut;
        
        dodge = [SKAction sequence:@[[SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Roll", self.texturePrefix]]], rotate, [SKAction setTexture:currentTexture], [SKAction runBlock:^{ isDodging = NO; }]]];
        
        
        [self.physicsBody applyImpulse:CGVectorMake(rollDirection, 50)];
    }else{
        //Backstep
        dodge = [SKAction sequence:@[[SKAction waitForDuration:.4], [SKAction runBlock:^{
            isDodging = NO;
        }]]];
        
        [self.physicsBody applyImpulse:CGVectorMake(rollDirection, 18)];
    }
    
    [self.graphics runAction:dodge];
}

-(void)attackWithType:(TGAttackType)type
{
    float angle = self.facing == TGDirectionRight ? -2 : 2;
    
    float initSwordRotation = swordRotation;
    swordRotation = angle;
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5], [SKAction runBlock:^{
        swordRotation = initSwordRotation;
    }]]]];
    
    //[sword.physicsBody applyAngularImpulse:type == TGAttackTypeWeak ? 0.01 : .05];
}

@end