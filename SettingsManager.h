//
//  SettingsManager.h
//  OOOTouch
//
//  Created by Edward Rudd on 4/7/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsManager : NSObject {
    NSString *_file;
}
- (NSDictionary *)config;

- (id)initWithSettingsFile: (NSString *)plistfile;

+ (SettingsManager *)settingsManagerWithSettingsFile: (NSString *)plistfile;

- (UIViewController *)settingsViewController;

@end
