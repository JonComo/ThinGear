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

static const uint32_t TGColliderTypeNone        = 0x1 << 0;
static const uint32_t TGColliderTypeNoCollide   = 0x1 << 1;
static const uint32_t TGColliderTypeCharacter   = 0x1 << 2;
static const uint32_t TGColliderTypeGround      = 0x1 << 3;
static const uint32_t TGColliderTypeWeapon      = 0x1 << 4;

#import "TGSprite.h"
#import "TGEquip.h"

@interface TGCharacter : TGSprite

@property (nonatomic, strong) NSString *texturePrefix;
@property (nonatomic, assign) TGDirection facing;
@property (nonatomic, strong) SKSpriteNode *graphics;

@property (nonatomic, strong) TGEquip *equipA;
@property (nonatomic, strong) TGEquip *equipB;

@property (nonatomic, weak) TGCharacter *target;

@property float speed;

@property BOOL walkLeft;
@property BOOL walkRight;

-(id)initWithPosition:(CGPoint)position texturePrefix:(NSString *)texPrefix scene:(SKScene *)scene;

-(void)dodgeInDirection:(TGDirection)direction;

@end
