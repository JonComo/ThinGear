//
//  TGButton.h
//  ThinGear
//
//  Created by Jon Como on 2/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void (^TGActionBlock)(BOOL wasPressed, BOOL wasReleased, BOOL wasDoubleTapped);

@interface TGButton : SKSpriteNode

@property (nonatomic, strong) TGActionBlock actionBlock;

+(TGButton *)buttonWithActionBlock:(TGActionBlock)block;

@end