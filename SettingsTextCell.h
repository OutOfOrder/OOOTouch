//
//  SettingsTextCell.h
//  OOOTouch
//
//  Created by Edward Rudd on 4/8/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsTextCell : UITableViewCell <UITextFieldDelegate>
{
    UITextField *_textField;
}

@property (nonatomic,readonly,retain) UITextField *textField;

@end

