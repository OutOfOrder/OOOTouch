//
//  SettingsValueTable.h
//  OOOTouch
//
//  Created by Edward Rudd on 4/8/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsValueTable : UITableViewController {
    NSDictionary *_setting;
    NSArray *_values;
    NSArray *_titles;
    id _currentValue;
}

/** Internal properties for lazy loading */
@property (nonatomic,readonly,retain) NSArray *values;
@property (nonatomic,readonly,retain) NSArray *titles;

- (id)initWithSetting:(NSDictionary *)setting;

@end
