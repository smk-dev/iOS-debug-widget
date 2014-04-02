//
//  SMKFirstViewController.m
//  iOS debug widget example
//
//  Created by smk-dev on 15.02.2014.
//  Copyright (c) 2014 smk-dev. All rights reserved.
//

#import "SMKFirstViewController.h"
#import "SMKDebugWidget.h" //Add this to views that wish to displat NSLogs in widget

@interface SMKFirstViewController ()

@end

@implementation SMKFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"This is log test One!");
    NSLog(@"This is log test Two!");
    NSLog(@"Log me too!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
