//
//  OOOTouchDemoAppDelegate.h
//  OOTouch Demo
//
//  Created by Edward Rudd on 4/25/10.
//  Copyright OutOfOrder.cc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface OOOTouchDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;

- (NSString *)applicationDocumentsDirectory;
- (NSString *)settingsBundle;

- (IBAction) showSettings:(id) button;
@end

