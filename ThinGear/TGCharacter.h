//
//  TGCharacter.h
//  ThinGear
//
//  Created by Jon Como on 2/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

typedef enum
{
    TGDirectionRight,
    TGDirectionLeft
} TGDirection;

typedef enum
{
    TGAttackTypeStrong,
    TGAttackTypeWeak
} TGAttackType;

typedef enum : uint8_t {
    TGColliderTypeCharacter     = 1,
    TGColliderTypeGround        = 2,
    TGColliderTypeWeapon        = 4
} TGColliderType;

#import <SpriteKit/SpriteKit.h>

@interface TGCharacter : SKSpriteNode

@property (nonatomic, strong) NSString *texturePrefix;
@property (nonatomic, assign) TGDirection facing;
@property (nonatomic, strong) SKSpriteNode *graphics;

@property (nonatomic, weak) TGCharacter *target;

@property float speed;

@property BOOL walkLeft;
@property BOOL walkRight;

-(id)initWithPosition:(CGPoint)position texturePrefix:(NSString *)texPrefix scene:(SKScene *)scene;

-(void)dodgeInDirection:(TGDirection)direction;
-(void)attackWithType:(TGAttackType)type;

-(void)update:(NSTimeInterval)currentTime;
-(void)didSimulatePhysics;

@end
