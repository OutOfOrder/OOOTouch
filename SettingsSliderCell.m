//
//  SettingsSliderCell.m
//  OOOTouch
//
//  Created by Edward Rudd on 4/8/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import "SettingsSliderCell.h"

@implementation SettingsSliderCell

@synthesize slider = _slider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_slider];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
	// determine the content rect for the cell. This will change depending on the
	// style of table (grouped vs plain)
	CGRect contentRect = self.contentView.bounds;
    contentRect.origin.x += 10;
    contentRect.size.width -= 20;
	_slider.frame = contentRect;
}

- (void) dealloc
{
    [_slider release];
    [super dealloc];
}

@end
