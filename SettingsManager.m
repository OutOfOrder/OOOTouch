//
//  SettingsManager.m
//  OOOTouch
//
//  Created by Edward Rudd on 4/7/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import "SettingsManager.h"

#import "SettingsViewController.h"

@implementation SettingsManager

+(SettingsManager *) settingsManagerWithSettingsBundle:(NSString *)plistfile {
    return [[[SettingsManager alloc] initWithSettingsBundle: plistfile] autorelease];
}

- (id) initWithSettingsBundle:(NSString *)plistfile {
    self = [super init];
    if (self != nil) {
        _bundle = [[NSBundle alloc] initWithPath:plistfile];
    }
    return self;
}

- (NSDictionary *) config {
    // Find main settings file.
    NSString *_file = [_bundle pathForResource:@"Root" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:_file];
}

- (UIViewController *) settingsViewController {
    SettingsViewController *settings = [[[SettingsViewController alloc] initWithSettings:self] autorelease];
    return settings;
}

- (void) presentModelSettingsViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *vc = [self settingsViewController];
    _tempVC = viewController;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" 
                                                             style:UIBarButtonItemStylePlain 
                                                            target:self 
                                                            action:@selector(dismiss:)];
    [[vc navigationItem] setRightBarButtonItem:item];
    [item release];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [viewController presentModalViewController:nc animated:animated];
    [nc release];
}

- (void) dismiss:(id)button
{
    [_tempVC dismissModalViewControllerAnimated:YES];
    _tempVC = nil;
}

/**
 * Returns a dictionary that contains all the keys and defaults.
 * Return value is mutable so the application can add anything extra
 * defaults before handing off to NSUserDefaults
 */
- (NSMutableDictionary *) defaultSettings
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *plist = [[self config] objectForKey:@"PreferenceSpecifiers"];
    for (NSDictionary* option in plist) {
        NSString *key = [option objectForKey:@"Key"];
        if (key) {
            [dict setObject:[option objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    return dict;
}

- (void) dealloc
{
    [_bundle release];

    [super dealloc];
}

@end
