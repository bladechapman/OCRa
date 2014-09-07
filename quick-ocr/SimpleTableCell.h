//
//  SimpleTableCell.h
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;


@end
