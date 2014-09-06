//
//  ListItemStore.h
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListItem.h"

@interface ListItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (ListItemStore *)sharedStore;
- (NSArray *)allItems;
- (void)addItem:(ListItem *)item;
- (void)removeItemAtIndex:(NSInteger)index;

@end
