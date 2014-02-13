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
}

-(id)initWithTexturePrefix:(NSString *)texPrefix
{
    SKTexture *texture = [SKTexture textureWithImageNamed:texPrefix]; //idle
    
    if (self = [super initWithColor:[UIColor clearColor] size:texture.size]) {
        //init
        _texturePrefix = texPrefix;
        _graphics = [[SKSpriteNode alloc] initWithTexture:texture];
        [self addChild:_graphics];
        
        self.speed = 300;
        _facing = TGDirectionRight;
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.mass = 0.1;
        self.physicsBody.friction = 0.4;
        self.physicsBody.allowsRotation = NO;
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

@end