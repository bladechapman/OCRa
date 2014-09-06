//
//  ListItem.h
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject

@property UIImage *image;
@property BOOL isLoaded;
@property NSString *text;

- (id)initWithImage:(UIImage *)image andLoaded:(BOOL)loaded andText:(NSString *)text;

@end
