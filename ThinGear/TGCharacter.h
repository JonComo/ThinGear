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

#import <SpriteKit/SpriteKit.h>

@interface TGCharacter : SKSpriteNode

@property (nonatomic, strong) NSString *texturePrefix;
@property (nonatomic, assign) TGDirection facing;
@property (nonatomic, strong) SKSpriteNode *graphics;

@property (nonatomic, weak) TGCharacter *target;

@property float speed;

@property BOOL walkLeft;
@property BOOL walkRight;

-(id)initWithTexturePrefix:(NSString *)texPrefix;

-(void)dodgeInDirection:(TGDirection)direction;

-(void)update:(NSTimeInterval)currentTime;

@end
