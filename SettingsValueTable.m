//
//  SettingsValueTable.m
//  OOOTouch
//
//  Created by Edward Rudd on 4/8/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import "SettingsValueTable.h"


@implementation SettingsValueTable


#pragma mark -
#pragma mark Initialization


- (id) initWithOption:(NSDictionary *)option forSettings:(SettingsManager *)settings {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        _option = [option retain];
        _settingsManager = [settings retain];
        NSString *key = [_option valueForKey:@"Key"];
        _currentValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return self;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Fixed at one section
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.values count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSObject *_curVal = [self.values objectAtIndex:indexPath.row];
    if ([_curVal isEqual:_currentValue]) {        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    // @todo localize
    [[cell textLabel] setText:[self.titles objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger curIdx = [self.values indexOfObjectIdenticalTo:_currentValue];
    if (curIdx != indexPath.row) {
        SEL action = NSSelectorFromString([_option valueForKey:@"ItemSelectAction"]);
        if (action && [_settingsManager.delegate respondsToSelector:action]) {
            [_settingsManager.delegate 
                    performSelector:action 
                    withObject:[self.values objectAtIndex:indexPath.row]];
        }
        // Unset old one
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:
                                    [NSIndexPath indexPathForRow:curIdx inSection:indexPath.section]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        // Set new one
        cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        _currentValue = [self.values objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:_currentValue forKey:[_option objectForKey:@"Key"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Lazy Loading

- (NSArray *)values {
    if (!_values) {
        _values = [_option valueForKey:@"Values"];
    }
    return _values;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = [_option valueForKey:@"Titles"];
    }
    return _titles;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [_option release];
    [_settingsManager release];

    [super dealloc];
}


@end

