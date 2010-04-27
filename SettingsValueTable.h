//
//  SettingsValueTable.h
//  OOOTouch
//
//  Created by Edward Rudd on 4/8/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsManager.h"

@interface SettingsValueTable : UITableViewController {
    NSDictionary *_option;
    SettingsManager *_settingsManager;
    NSArray *_values;
    NSArray *_titles;
    id _currentValue;
}

/** Internal properties for lazy loading */
@property (nonatomic,readonly,retain) NSArray *values;
@property (nonatomic,readonly,retain) NSArray *titles;

- (id) initWithOption:(NSDictionary *)option forSettings:(SettingsManager *)settings;

@end
