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

@synthesize delegate = _delegate;

+(SettingsManager *) settingsManagerWithSettingsBundle:(NSString *)plistfile {
    return [[[SettingsManager alloc] initWithSettingsBundle: plistfile] autorelease];
}

- (id) initWithSettingsBundle:(NSString *)plistfile {
    self = [super init];
    if (self != nil) {
        _delegate = nil;
        _bundle = [[NSBundle alloc] initWithPath:plistfile];
    }
    return self;
}

- (NSDictionary *) config {
    // Find main settings file.
    NSString *_file = [_bundle pathForResource:@"Root" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:_file];
}

- (void) pushSettingsViewControllerOnNavigationController:(UINavigationController *)nc animaed:(BOOL)animated {
    SettingsViewController *settings = [[[SettingsViewController alloc] initWithSettings:self] autorelease];
    [nc pushViewController:settings animated:animated];
}

- (void) presentModelSettingsViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *vc = [[[SettingsViewController alloc] initWithSettings:self] autorelease];
    if (_tempVC) {
        NSException *e = [NSException
                          exceptionWithName:@"InvalidCallException"
                          reason:@"Settings Dialog Already Visible"
                          userInfo:nil];
        @throw e;
    }
    _tempVC = viewController;
    if ([_delegate respondsToSelector:@selector(settingsManager:willShowSettingsViewController:)]) {
        [_delegate settingsManager:self willShowSettingsViewController:vc];
    } else {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" 
                                                                 style:UIBarButtonItemStylePlain 
                                                                target:self 
                                                                action:@selector(dismiss:)];
        [[vc navigationItem] setRightBarButtonItem:item];
        [item release];
    }
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
