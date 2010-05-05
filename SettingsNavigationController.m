    //
//  SettingsNavigationController.m
//  OOOTouch
//
//  Created by Edward Rudd on 5/1/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import "SettingsNavigationController.h"


@implementation SettingsNavigationController

@synthesize shouldRotate = _shouldRotate;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return _shouldRotate ? YES : (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
