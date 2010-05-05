//
//  SettingsNavigationController.h
//  OOOTouch
//
//  Created by Edward Rudd on 5/1/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsNavigationController : UINavigationController {
    BOOL _shouldRotate;
}

@property (nonatomic,assign) BOOL shouldRotate;

@end
