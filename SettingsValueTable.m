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


- (id) initWithSetting:(NSDictionary *)setting {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        _setting = [setting retain];
        _currentValue = [_setting valueForKey:@"DefaultValue"];
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tap: %d / %d", indexPath.section, indexPath.row);

    NSInteger curIdx = [self.values indexOfObjectIdenticalTo:_currentValue];
    if (curIdx != indexPath.row) {
        // Unset old one
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:
                                    [NSIndexPath indexPathForRow:curIdx inSection:indexPath.section]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        // Set new one
        cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        _currentValue = [self.values objectAtIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Lazy Loading

- (NSArray *)values {
    if (!_values) {
        _values = [_setting valueForKey:@"Values"];
    }
    return _values;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = [_setting valueForKey:@"Titles"];
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
    [_setting release];

    [super dealloc];
}


@end

