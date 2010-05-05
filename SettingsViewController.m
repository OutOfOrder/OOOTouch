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

@synthesize schema = _schema;

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
        _settingsManager = [settings retain];
        _config = nil;
        _predicate = nil;
        _groups = nil;
        _settings = [NSUserDefaults standardUserDefaults];
        _schema = nil;
    }
    return self;
}

- (id)initWithSettings:(SettingsManager *)settings andSchema:(NSString *)schema {
    self = [self initWithSettings:settings];
    if (self != nil) {
        _schema = [schema copy];
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated
{
    NSIndexPath *cur = [self.tableView indexPathForSelectedRow];
    if (cur != nil) {
        NSInteger first = [self.allitems indexOfObjectIdenticalTo:[self.groups objectAtIndex:cur.section]];
        NSDictionary *obj = [self.allitems objectAtIndex:first + 1 + cur.row];
        NSString *type = [obj valueForKey:@"Type"];
        if ([type isEqualToString:@"PSMultiValueSpecifier"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cur];
            id _val = [[NSUserDefaults standardUserDefaults] objectForKey:[obj objectForKey:@"Key"]];
            NSInteger idx = [[obj valueForKey:@"Values"] indexOfObject:_val];
            if (idx != NSNotFound) {
                [[cell detailTextLabel] setText:[[obj valueForKey:@"Titles"] objectAtIndex:idx]];
                // This is to adjust width and left offset of detailTextLabel BEFORE we animate back
                [cell setNeedsLayout];
                [cell layoutIfNeeded];
            }
        }
    }
    [super viewWillAppear:animated];
}

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
                UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectZero];
                [cell setAccessoryView:switchObj];
                [switchObj addTarget:self action:@selector(switchToggle:) forControlEvents:UIControlEventValueChanged];
                [switchObj release];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                break;
            case SettingsTypeSlider:
                cell = [[[SettingsSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
                [[(SettingsSliderCell *)cell slider] addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
                break;
            case SettingsTypeText:
                cell = [[[SettingsTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
                [[(SettingsTextCell *)cell textField] setDelegate:self];
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
    NSInteger grpIdx = [self.allitems indexOfObjectIdenticalTo:[self.groups objectAtIndex:indexPath.section]];
    NSInteger settingIdx = grpIdx + 1 + indexPath.row;
    NSDictionary *option = [self.allitems objectAtIndex:settingIdx];

    UITableViewCell *cell = nil;
    NSString *valueText = @"";
    id value = nil;
    /** @todo add Localization Support */
    NSString *key = [option valueForKey:@"Key"];
    if (key) {
        value = [_settings objectForKey:key];
        if (value) {
            if ([value respondsToSelector: @selector(stringValue)]) {
                valueText = [value stringValue];
            } else {
                valueText = value;
            }
        }
    }
    
    NSString *type = [option valueForKey:@"Type"];
    if ([type isEqualToString:@"PSMultiValueSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeMulti withId:@"CellMulti"];
        [[cell textLabel] setText:[option valueForKey:@"Title"]];
        NSInteger idx = [[option valueForKey:@"Values"] indexOfObject:value];
        if (idx != NSNotFound) {
            [[cell detailTextLabel] setText:[[option valueForKey:@"Titles"] objectAtIndex:idx]];            
        }
        
    } else if ([type isEqualToString:@"PSTextFieldSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeText withId:@"CellText"];
        [[cell textLabel] setText:[option valueForKey:@"Title"]];
        UITextField *tf = [(SettingsTextCell *)cell textField];
        tf.text = valueText;
        tf.tag = settingIdx;
        NSNumber *secure = [option objectForKey:@"IsSecure"];
        tf.secureTextEntry = (secure && [secure boolValue]);
        NSString *opt = [option objectForKey:@"KeyboardType"];
        if (opt) {
            if ([opt isEqualToString:@"NumbersAndPunctuation"]) {
                tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            } else if ([opt isEqualToString:@"NumberPad"]) {
                tf.keyboardType = UIKeyboardTypeNumberPad;
            } else if ([opt isEqualToString:@"URL"]) {
                tf.keyboardType = UIKeyboardTypeURL;
            } else if ([opt isEqualToString:@"EmailAddress"]) {
                tf.keyboardType = UIKeyboardTypeEmailAddress;
            } else {
                tf.keyboardType = UIKeyboardTypeAlphabet;
            }
        } else {
            tf.keyboardType = UIKeyboardTypeAlphabet;
        }
        opt = [option objectForKey:@"AutocapitalizationType"];
        if (opt) {
            if ([opt isEqualToString:@"Sentences"]) {
                tf.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            } else if ([opt isEqualToString:@"Words"]) {
                tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
            } else if ([opt isEqualToString:@"AllCharacters"]) {
                tf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            } else {
                tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            }            
        } else {
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        opt = [option objectForKey:@"AutocorrectionType"];
        if (opt) {
            if ([opt isEqualToString:@"No"]) {
                tf.autocorrectionType = UITextAutocorrectionTypeNo;
            } else if ([opt isEqualToString:@"Yes"]) {
                tf.autocorrectionType = UITextAutocorrectionTypeYes;
            } else {
                tf.autocorrectionType = UITextAutocorrectionTypeDefault;
            }            
        } else {
            tf.autocorrectionType = UITextAutocorrectionTypeDefault;
        }

    } else if ([type isEqualToString:@"PSSliderSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeSlider withId:@"CellSlider"];
        UISlider *sl = (UISlider *)[(SettingsSliderCell *)cell slider];
        sl.tag = settingIdx;
        sl.value = [value floatValue];
        sl.minimumValue = [[option objectForKey:@"MinimumValue"] floatValue];
        sl.maximumValue = [[option objectForKey:@"MaximumValue"] floatValue];
        
    } else if ([type isEqualToString:@"PSToggleSwitchSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeToggle withId:@"CellToggle"];
        [[cell textLabel] setText:[option valueForKey:@"Title"]];
        UISwitch *sw = (UISwitch *)[cell accessoryView];
        [sw setTag:settingIdx];
        [sw setOn:[value boolValue]];
        
    } else if ([type isEqualToString:@"PSTitleValueSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeTitle withId:@"CellTitle"];
        [[cell textLabel] setText:[option valueForKey:@"Title"]];
        [[cell detailTextLabel] setText:[option valueForKey:@"defaultValue"]];
        [[cell detailTextLabel] setText:valueText];

    } else if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
        cell = [self fetchCellForTableView:tableView ofType: SettingsTypeChild withId:@"CellChild"];
        [[cell textLabel] setText:[option valueForKey:@"Title"]];

    } else {
        NSLog(@"Unknown Type %@ for %@",type, indexPath);
        cell = [self fetchCellForTableView:tableView ofType:SettingsTypeUnknown withId:@"Cell"];
    }

    return cell;
}

#pragma mark -
#pragma mark Callbacks

- (void)switchToggle:(UISwitch *)switchObj
{
    NSDictionary *obj = [self.allitems objectAtIndex:switchObj.tag];
    NSString *key = [obj objectForKey:@"Key"];
    if (key) {
        [_settings setBool:switchObj.on forKey:key];
    }
    [_settingsManager callValueChangeActionForOption:obj withValue:[NSNumber numberWithBool:switchObj.on]];
}

- (void)sliderChange:(UISlider *)sliderObj
{
    NSDictionary *obj = [self.allitems objectAtIndex:sliderObj.tag];
    NSNumber *stepNum = [obj objectForKey:@"StepValue"];
    if (stepNum) {
        float step = [stepNum floatValue];
        float min = [[obj objectForKey:@"MinimumValue"] floatValue];
        sliderObj.value = (round((sliderObj.value - min) / step) * step) + min;
    }
    NSString *key = [obj objectForKey:@"Key"];
    if (sliderObj.value != [_settings floatForKey:key]) {
        if (key) {
            [_settings setFloat:sliderObj.value forKey:key];
        }
        [_settingsManager callValueChangeActionForOption:obj withValue:[NSNumber numberWithFloat:sliderObj.value]];
    }
}

#pragma mark Text Field Delegate

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSDictionary *obj = [self.allitems objectAtIndex:textField.tag];
    NSString *key = [obj objectForKey:@"Key"];
    if (key) {
        [_settings setObject:textField.text forKey:key];
    }
    [_settingsManager callValueChangeActionForOption:obj withValue:textField.text];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger first = [self.allitems indexOfObjectIdenticalTo:[self.groups objectAtIndex:indexPath.section]];
    NSDictionary *obj = [self.allitems objectAtIndex:first + 1 + indexPath.row];
    NSString *type = [obj valueForKey:@"Type"];
    if ([type isEqualToString:@"PSMultiValueSpecifier"]) {
        SettingsValueTable *viewController = [[SettingsValueTable alloc] initWithOption:obj forSettings:_settingsManager];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
        SettingsViewController *vc = [[SettingsViewController alloc] initWithSettings:_settingsManager andSchema:[obj valueForKey:@"File"]];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }

}

#pragma mark -
#pragma mark Lazy Loading

- (NSDictionary *)config {
    if (!_config) {
        _config = [[_settingsManager configForSchema:_schema] retain];
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

- (void) setSchema:(NSString *)schema {
    [_schema release];
    _schema = [schema copy];
    [_config release];
    _config = nil;
    [_groups release];
    _groups = nil;
    _allitems = nil;
    [self.tableView reloadData];
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
    [_settingsManager release];

    [super dealloc];
}


@end

