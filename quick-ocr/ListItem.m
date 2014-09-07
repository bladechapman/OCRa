//
//  ListItem.m
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

- (id)init {
    return [self initWithImage:nil andLoaded:NO andText:nil andLink:nil];
}
- (id)initWithImage:(UIImage *)image andLoaded:(BOOL)loaded andText:(NSString *)text andLink:(NSString *)link {
    if (self = [super init]) {
        (image == nil) ? (_image = [[UIImage alloc] init]) : (_image = image);
        _isLoaded = loaded;
        (text == nil) ? (_text = @"Loading...") : (_text = text);
        (link == nil) ? (_link = @"") : (_link = link);
    }

    return self;
}

@end
