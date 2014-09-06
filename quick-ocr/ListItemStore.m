//
//  ListItemStore.m
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import "ListItemStore.h"

@implementation ListItemStore

+ (ListItemStore *)sharedStore {
    static ListItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }

    return sharedStore;
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        allItems = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSArray *)allItems
{
    return allItems;
}
- (void)addItem:(ListItem *)item
{
    [allItems addObject:item];
}
- (void)removeItemAtIndex:(NSInteger)index
{
    [allItems removeObjectAtIndex:index];
}
@end
