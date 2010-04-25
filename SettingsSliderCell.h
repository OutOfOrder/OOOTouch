//
//  SettingsSliderCell.h
//  OOOTouch
//
//  Created by Edward Rudd on 4/8/10.
//  Copyright 2010 OutOfOrder.cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsSliderCell : UITableViewCell
{
    UISlider *_slider;
}

@property (nonatomic,readonly,retain) UISlider *slider;

@end
