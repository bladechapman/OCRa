//
//  CustomTableViewCell.m
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;

        // Initialize Main Label
        self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, size.width - 16.0, size.height - 16.0)];

        // Configure Main Label
        [self.mainLabel setFont:[UIFont boldSystemFontOfSize:24.0]];
        [self.mainLabel setTextAlignment:NSTextAlignmentCenter];
        [self.mainLabel setTextColor:[UIColor orangeColor]];
        [self.mainLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

        // Add Main Label to Content View
        [self.contentView addSubview:self.mainLabel];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
