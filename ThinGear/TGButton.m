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
    TGButton *button = [[TGButton alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(90, 90)];
    
    button.userInteractionEnabled = YES;
    button.actionBlock = block;
    button.alpha = 0.3;
    
    return button;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.actionBlock) self.actionBlock(YES, NO, shouldDoubleTap);
    
    shouldDoubleTap = YES;
    timerDoubleTap = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(resetDoubleTapCheck) userInfo:nil repeats:NO];
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