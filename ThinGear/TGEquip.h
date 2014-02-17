//
//  TGEquip.h
//  ThinGear
//
//  Created by Jon Como on 2/16/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGSprite.h"

@class TGCharacter;
@class TGEquip;

typedef enum
{
    TGStrengthStrong,
    TGStrengthWeak
} TGStrength;

@interface TGEquip : TGSprite

@property BOOL isTriggered;
@property BOOL isResetting;
@property BOOL isCollidable;

@property CGPoint centerOffset;

@property (nonatomic, weak) TGCharacter *character;
@property (nonatomic, strong) SKSpriteNode *spriteAnimated;
@property (nonatomic, strong) SKSpriteNode *graphics;

-(void)triggerWithStrength:(TGStrength)strength;
-(void)releaseTrigger;

@end