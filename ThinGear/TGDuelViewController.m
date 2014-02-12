//
//  TGDuelViewController.m
//  ThinGear
//
//  Created by Jon Como on 2/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TGDuelViewController.h"

#import "TGDuelScene.h"

@interface TGDuelViewController ()
{
    TGDuelScene *duelScene;
}

@end

@implementation TGDuelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    duelScene = [[TGDuelScene alloc] initWithSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.width)];
    duelScene.scaleMode = SKSceneScaleModeAspectFit;
    
    SKView *view = (SKView *)self.view;
    view.showsFPS = YES;
    
    [view presentScene:duelScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end