//
//  TGAction.m
//  ThinGear
//
//  Created by Jon Como on 2/16/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGAction.h"

@implementation TGAction

+(SKAction *)bodyHitSound
{
    return [SKAction playSoundFileNamed:@"hit.wav" waitForCompletion:NO];
}

@end