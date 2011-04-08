//
//  SettingsManager.m
//  OOOTouch
//
//  Created by Edward Rudd on 4/7/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import "SettingsManager.h"

#import "SettingsViewController.h"
#import "SettingsNavigationController.h"

@implementation SettingsManager

@synthesize delegate = _delegate;

+(SettingsManager *) settingsManagerWithSettingsBundle:(NSString *)bundlefile {
    return [[[SettingsManager alloc] initWithSettingsBundle: bundlefile] autorelease];
}

- (id) initWithSettingsBundle:(NSString *)bundlefile {
    self = [super init];
    if (self != nil) {
        _delegate = nil;
        _bundle = [[NSBundle alloc] initWithPath:bundlefile];
        if (_bundle == nil) {
            // Throw bad error?
            [NSException raise:@"MissingBundleException" format:@"Could not find Settings Bundle %@",bundlefile];
        }
    }
    return self;
}

- (NSDictionary *) config {
    // Find main settings file.
    return [self configForSchema:@"Root"];
}

- (NSDictionary *)configForSchema: (NSString *)schema {
    if (schema == nil) {
        return [self config];
    }
    NSString *_file = [_bundle pathForResource:schema ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:_file];
}

- (UIViewController *)settingsViewController {
    return [[[SettingsViewController alloc] initWithSettings:self] autorelease];
}

- (void) pushSettingsViewControllerOnNavigationController:(UINavigationController *)nc animaed:(BOOL)animated {
    [nc pushViewController:[self settingsViewController] animated:animated];
}

- (void) presentModelSettingsViewController:(UIViewController *)viewController 
                                animated:(BOOL)animated withStyle:(UIModalTransitionStyle)style {
    if (_tempVC) {
        [NSException raise:@"InvalidCallException" format:@"Settings Dialog Already Visible"];
    }
    UIViewController *vc = [self settingsViewController];
    _tempVC = viewController;
    if ([_delegate respondsToSelector:@selector(settingsManager:willShowSettingsViewController:)]) {
        [_delegate settingsManager:self willShowSettingsViewController:vc];
    } else {
        [_tempVC retain];
        [self retain];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" 
                                                                 style:UIBarButtonItemStylePlain 
                                                                target:self 
                                                                action:@selector(dismiss:)];
        [[vc navigationItem] setRightBarButtonItem:item];
        [item release];
    }
    SettingsNavigationController *nc = [[SettingsNavigationController alloc] initWithRootViewController:vc];
    nc.modalTransitionStyle = style;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    // iPad Magic so the settings view isn't "full screen"
    if ([nc respondsToSelector:@selector(setModalPresentationStyle:)]) {
        [nc setModalPresentationStyle:UIModalPresentationFormSheet];
        nc.shouldRotate = YES;
    }
#endif
    [viewController presentModalViewController:nc animated:animated];
    [nc release];
}

- (void) dismiss:(id)button
{
    [_tempVC dismissModalViewControllerAnimated:YES];
    [_tempVC release];
    _tempVC = nil;
    [self release];
}

- (void)addSettingsToDictionary:(NSMutableDictionary *)dict forSchema:(NSString *)schema
{
    NSDictionary *plist = [[self configForSchema:schema] objectForKey:@"PreferenceSpecifiers"];
    for (NSDictionary* option in plist) {
        NSString *key = [option objectForKey:@"Key"];
        if (key) {
            id def = [option objectForKey:@"DefaultValue"];
            if (def != nil) {
                [dict setObject: def forKey:key];
            } else {
                [dict setObject:@"" forKey:key];
            }
        }
        if ([[option objectForKey:@"Type"] isEqualToString:@"PSChildPaneSpecifier"]) {
            [self addSettingsToDictionary:dict forSchema: [option objectForKey:@"File"]];
        }
    }
}

/**
 * Returns a dictionary that contains all the keys and defaults.
 * Return value is mutable so the application can add anything extra
 * defaults before handing off to NSUserDefaults
 */
- (NSMutableDictionary *) defaultSettings
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self addSettingsToDictionary:dict forSchema: nil];
    return dict;
}

#pragma mark -
#pragma mark Delegate actions
- (void)callValueChangeActionForOption: (NSDictionary *)option withValue: (id) value {
    SEL action = NSSelectorFromString([option valueForKey:@"ValueChangeAction"]);
    if (action && [self.delegate respondsToSelector:action]) {
        [self.delegate performSelector:action withObject:option withObject:value];
    }    
}

#pragma mark -
#pragma mark Memory management

- (void) dealloc
{
    [_bundle release];

    [super dealloc];
}

@end
