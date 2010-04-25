//
//  SettingsController.m
//  MakeMyStatus
//
//  Created by Edward Rudd on 4/5/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsValueTable.h"
#import "SettingsSliderCell.h"
#import "SettingsTextCell.h"

#pragma mark -
#pragma mark SettingsController

@implementation SettingsViewController

enum {
    SettingsTypeUnknown,
    SettingsTypeToggle,
    SettingsTypeSlider,
    SettingsTypeTitle,
    SettingsTypeText,
    SettingsTypeMulti,
    SettingsTypeChild
};
typedef NSUInteger SettingsType;

#pragma mark -
#pragma mark View lifecycle
- (id)initWithSettings:(SettingsManager *)settings {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self != nil) {
        [self setTitle:@"Settings"];
        _settings = [settings retain];
        _config = nil;
        _predicate = nil;
        _groups = nil;
    }
    return self;
}

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
    // Return the number of sections.
    return [self.groups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.groups objectAtIndex:section] valueForKey:@"Title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger first = [self.allitems indexOfObjectIdenticalTo:[self.groups objectAtIndex:section]];
    NSInteger len = [self.allitems count];
    NSInteger pos;
    for (pos = first + 1; pos < len; ++pos) {
        if ([self.predicate evaluateWithObject:[self.allitems objectAtIndex:pos]]) {
            break;
        }
    }
    return pos - first - 1;
}

- (UITableViewCell *)fetchCellForTableView:(UITableView *)tableView ofType: (SettingsType)type withId:(NSString *)cellId {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        if (type != SettingsTypeSlider && type != SettingsTypeText) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId] autorelease];
        }
        switch (type) {
            case SettingsTypeMulti:
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            case SettingsTypeChild:
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            case SettingsTypeToggle: {
                UISlider *switchObj = [[UISwitch alloc] initWithFrame:CGRectZero];
                [cell setAccessoryView:switchObj];
                [switchObj release];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                break;
            case SettingsTypeSlider:
                cell = [[SettingsSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                break;
            case SettingsTypeText:
                cell = [[SettingsTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                break;                
            case SettingsTypeTitle:
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
            default:
                break;
        }
    }
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"delagate %@",[tableView delegate]);
    NSInteger first = [self.allitems indexOfObjectIdenticalTo:[self.groups objectAtIndex:indexPath.section]];
    NSDictionary *obj = [self.allitems objectAtIndex:first + 1 + indexPath.row];

    UITableViewCell *cell = nil;
    NSString *defValueText;
    /** @todo add Localization Support */
    id defValue = [obj valueForKey:@"DefaultValue"];
    if ([defValue respondsToSelector: @selector(stringValue)]) {
        defValueText = [defValue stringValue];
    } else {
        defValueText = defValue;
    }
    
    NSString *type = [obj valueForKey:@"Type"];
    if ([type isEqualToString:@"PSMultiValueSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeMulti withId:@"CellMulti"];
        [[cell textLabel] setText:[obj valueForKey:@"Title"]];
        NSInteger idx = [[obj valueForKey:@"Values"] indexOfObject:defValue];
        if (idx != NSNotFound) {
            [[cell detailTextLabel] setText:[[obj valueForKey:@"Titles"] objectAtIndex:idx]];            
        }
        
    } else if ([type isEqualToString:@"PSTextFieldSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeText withId:@"CellText"];
        [[cell textLabel] setText:[obj valueForKey:@"Title"]];
        [[(SettingsTextCell *)cell textField] setText:defValueText];
        
    } else if ([type isEqualToString:@"PSSliderSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeSlider withId:@"CellSlider"];
        
    } else if ([type isEqualToString:@"PSToggleSwitchSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeToggle withId:@"CellToggle"];
        [[cell textLabel] setText:[obj valueForKey:@"Title"]];
        
    } else if ([type isEqualToString:@"PSTitleValueSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeTitle withId:@"CellTitle"];
        [[cell textLabel] setText:[obj valueForKey:@"Title"]];
        [[cell detailTextLabel] setText:[obj valueForKey:@"defaultValue"]];
        [[cell detailTextLabel] setText:defValueText];

    } else if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeChild withId:@"CellChild"];
        [[cell textLabel] setText:[obj valueForKey:@"Title"]];

    } else {
        NSLog(@"Unknown Type %@ for %@",type, indexPath);
        cell = [self fetchCellForTableView:tableView ofType:SettingsTypeUnknown withId:@"Cell"];
    }

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
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
    NSInteger first = [self.allitems indexOfObjectIdenticalTo:[self.groups objectAtIndex:indexPath.section]];
    NSDictionary *obj = [self.allitems objectAtIndex:first + 1 + indexPath.row];
    NSString *type = [obj valueForKey:@"Type"];
    if ([type isEqualToString:@"PSMultiValueSpecifier"]) {
        SettingsValueTable *viewController = [[SettingsValueTable alloc] initWithSetting:obj];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

#pragma mark -
#pragma mark Lazy Loading

- (NSDictionary *)config {
    if (!_config) {
        _config = [[_settings config] retain];
    }
    return _config;
}

- (NSArray *)allitems {
    if (!_allitems) {
        _allitems  = [self.config objectForKey:@"PreferenceSpecifiers"];
    }
    return _allitems;
}

- (NSPredicate *)predicate {
    if (!_predicate) {
        _predicate = [[NSPredicate predicateWithFormat:@"Type == 'PSGroupSpecifier'"] retain];
    }
    return _predicate;
}

- (NSArray *)groups {
    if (!_groups) {
        _groups = [[self.allitems filteredArrayUsingPredicate:self.predicate] retain];
    }
    return _groups;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    [_predicate release];
    _predicate = nil;

    [_groups release];
    _groups = nil;
    
    [_config release];
    _config = nil;
    _allitems = nil;
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [_predicate release];
    [_groups release];
    [_config release];
    [_settings release];

    [super dealloc];
}


@end

