//
//  ListViewController.h
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListViewControllerDelegate;

@interface ListViewController : UITableViewController

@property id<ListViewControllerDelegate>delegate;

- (void)reload;

@end

@protocol ListViewControllerDelegate <NSObject>

- (void)goToCam;

@end
