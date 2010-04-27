//
//  SettingsTextCell.m
//  OOOTouch
//
//  Created by Edward Rudd on 4/8/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import "SettingsTextCell.h"


@implementation SettingsTextCell

@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.clearsOnBeginEditing = NO;
        _textField.returnKeyType = UIReturnKeyDone;
        // wish there was a constant for this.. this is "picked" from the existing controls
        _textField.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
		[self.contentView addSubview:_textField];
        self.textLabel.clipsToBounds = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
	// determine the content rect for the cell. This will change depending on the
	// style of table (grouped vs plain)
    CGRect labelRect = self.textLabel.frame;
    CGSize labelSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
    labelRect.size.width = labelSize.width;
    self.textLabel.frame = labelRect;
	CGRect contentRect = self.contentView.bounds;
    contentRect.origin.x += 10 + labelRect.size.width + labelRect.origin.x;
    contentRect.origin.y += 12;
    contentRect.size.width -= 20 + labelRect.size.width + labelRect.origin.x;
    contentRect.size.height = 25;
	_textField.frame = contentRect;
}

- (void) dealloc
{
    [_textField release];
    [super dealloc];
}

@end
