//
//  OOOTouchDemoAppDelegate.m
//  OOOTouch Demo
//
//  Created by Edward Rudd on 4/25/10.
//  Copyright OutOfOrder.cc 2010. All rights reserved.
//

#import "OOOTouchDemoAppDelegate.h"
#import "SettingsManager.h"

@implementation OOOTouchDemoAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // set default setttings
    SettingsManager *settings = [SettingsManager settingsManagerWithSettingsBundle:[self settingsBundle]];
    NSDictionary *dict = [settings defaultSettings];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];

    for (NSString *key in dict) {
        NSLog(@"%@: %@", key, [dict objectForKey:key]);
    }
    // Load window up
    [window addSubview:[viewController view]];
    [window makeKeyAndVisible];
    return YES;
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *) settingsBundle {
    return [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"bundle"];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    
    [viewController release];

    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Callbacks

- (void) showSettings:(id)button {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"bundle"];
    SettingsManager *settings = [SettingsManager settingsManagerWithSettingsBundle:file];
    [settings presentModelSettingsViewController:viewController animated:YES];
}

@end

