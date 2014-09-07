//
//  CustomTableViewCell.h
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTableViewCell : UITableViewCell

@property IBOutlet UILabel *centerTitle;
@property IBOutlet UIImageView *primaryImage;
@property BOOL loadingStatus;

@end