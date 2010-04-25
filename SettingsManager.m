//
//  SettingsManager.m
//  OOOTouch
//
//  Created by Edward Rudd on 4/7/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import "SettingsManager.h"

#import "SettingsViewController.h"

@implementation SettingsManager

+(SettingsManager *) settingsManagerWithSettingsFile:(NSString *)plistfile {
    return [[[SettingsManager alloc] initWithSettingsFile: plistfile] autorelease];
}

- (id) initWithSettingsFile:(NSString *)plistfile {
    self = [super init];
    if (self != nil) {
        _file = [plistfile copy];
    }
    return self;    
}

- (NSDictionary *) config {
    // Push Configuration Controller
    return [NSDictionary dictionaryWithContentsOfFile:_file];
}

- (UIViewController *) settingsViewController {
    SettingsViewController *settings = [[[SettingsViewController alloc] initWithSettings:self] autorelease];
    return settings;
}

- (void) dealloc
{
    [_file release];

    [super dealloc];
}

@end
