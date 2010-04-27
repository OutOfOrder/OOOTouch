//
//  SettingsManager.h
//  OOOTouch
//
//  Created by Edward Rudd on 4/7/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsManager : NSObject {
    NSBundle *_bundle;
    UIViewController *_tempVC;
}
- (NSDictionary *)config;

- (id)initWithSettingsBundle: (NSString *)plistfile;

+ (SettingsManager *)settingsManagerWithSettingsBundle: (NSString *)plistfile;

- (NSMutableDictionary *)defaultSettings;

- (UIViewController *)settingsViewController;
- (void) presentModelSettingsViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
