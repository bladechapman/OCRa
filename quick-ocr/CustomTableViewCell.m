//
//  CustomTableViewCell.m
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize centerTitle;
@synthesize primaryImage;
@synthesize indicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialize];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self initialize];
}

- (void)initialize {
//    if (primaryImage.frame.size.width != primaryImage.frame.size.height) {
//        primaryImage.frame = CGRectMake(0, 0, primaryImage.frame.size.width, primaryImage.frame.size.width);
//    }

    primaryImage.frame = CGRectMake(0, 0, 40, 40);

    primaryImage.layer.cornerRadius = primaryImage.frame.size.width/4.f;
    primaryImage.layer.masksToBounds = YES;

    self.clipsToBounds = YES;

    [self isLoaded:_loadingStatus];
}

- (void)isLoaded:(BOOL)isLoaded
{
    if (isLoaded) {
        self.indicator.hidden = YES;
    }
    else {
        self.indicator.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
