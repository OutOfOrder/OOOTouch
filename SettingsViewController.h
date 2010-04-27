//
//  SettingsController.h
//  MakeMyStatus
//
//  Created by Edward Rudd on 4/5/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingsManager.h"

@interface SettingsViewController : UITableViewController <UITextFieldDelegate> {
    SettingsManager *_settingsManager;
    NSDictionary *_config;
    NSArray *_allitems, *_groups;
    NSPredicate *_predicate;
    NSUserDefaults *_settings;
}

/** Internal properties for lazy loading */
@property (nonatomic,readonly,retain) NSDictionary *config;
@property (nonatomic,readonly,retain) NSArray *allitems;
@property (nonatomic,readonly,retain) NSArray *groups;
@property (nonatomic,readonly,retain) NSPredicate *predicate;


- (id)initWithSettings:(SettingsManager *)settings;

@end
