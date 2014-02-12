//
//  TGButton.m
//  ThinGear
//
//  Created by Jon Como on 2/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGButton.h"

@implementation TGButton
{
    NSTimer *timerDoubleTap;
    BOOL shouldDoubleTap;
}

+(TGButton *)buttonWithActionBlock:(TGActionBlock)block
{
    TGButton *button = [[TGButton alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(60, 60)];
    
    button.userInteractionEnabled = YES;
    button.actionBlock = block;
    
    return button;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.actionBlock) self.actionBlock(YES, NO, shouldDoubleTap);
    
    shouldDoubleTap = YES;
    timerDoubleTap = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(resetDoubleTapCheck) userInfo:nil repeats:NO];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.actionBlock) self.actionBlock(NO, YES, NO);
}

-(void)resetDoubleTapCheck
{
    shouldDoubleTap = NO;
}

@end