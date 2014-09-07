//
//  ListViewController.h
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

@protocol ListViewControllerDelegate;

@interface ListViewController : UITableViewController

@property id<ListViewControllerDelegate>delegate;

- (void)reload;
- (void)updateItemAtIndex:(NSInteger)index andTitle:(NSString *)title andLinks:(NSArray *)linksArray;
- (void)updateUnloadedItemWithTitle:(NSString *)title;

@end

@protocol ListViewControllerDelegate <NSObject>

- (void)goToCam;

@end
