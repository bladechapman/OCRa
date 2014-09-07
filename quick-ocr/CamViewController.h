//
//  CamViewController.h
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CamViewControllerDelegate;

@interface CamViewController : UIViewController
@property id<CamViewControllerDelegate> delegate;
@end


@protocol CamViewControllerDelegate <NSObject>

- (void)imageCaptured:(UIImage *)image;
- (void)dataReceived:(NSData *)data;

@end
