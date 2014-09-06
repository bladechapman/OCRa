//
//  CustomScrollView.m
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import "CustomScrollView.h"
#import "ListViewController.h"

@implementation CustomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    self.scrollEnabled = YES;
    
    for (UIView *sub in view.subviews) {
        if (self.contentOffset.x >= 320 && [sub isKindOfClass:[UIImageView class]]) {
            self.scrollEnabled = NO;
            break;
//            return sub;
        } else {
            self.scrollEnabled = YES;
        }

    }

    return [super hitTest:point withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
