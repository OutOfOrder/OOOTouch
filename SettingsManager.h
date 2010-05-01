//
//  SettingsManager.h
//  OOOTouch
//
//  Created by Edward Rudd on 4/7/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsManagerDelegate;

@interface SettingsManager : NSObject {
    NSBundle *_bundle;
    UIViewController *_tempVC;
    id _delegate;
}
@property (nonatomic,assign) id<SettingsManagerDelegate> delegate;

- (NSDictionary *)config;

- (id)initWithSettingsBundle: (NSString *)plistfile;

+ (SettingsManager *)settingsManagerWithSettingsBundle: (NSString *)plistfile;

- (NSMutableDictionary *)defaultSettings;

- (void) pushSettingsViewControllerOnNavigationController:(UINavigationController *)nc animaed:(BOOL)animated;
- (void) presentModelSettingsViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@protocol SettingsManagerDelegate <NSObject>

@optional

- (void)settingsManager:(SettingsManager*)manager willShowSettingsViewController:(UIViewController *)viewController;

@end

