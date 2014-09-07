//
//  ListViewController.m
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import "ListViewController.h"
#import "ListItemStore.h"
#import "ListItem.h"
#import "CustomTableViewCell.h"

@interface ListViewController () {
    NSInteger selectedPath;
}

@end

@implementation ListViewController


-(id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        UINavigationItem *n = [self navigationItem];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [[UINavigationBar appearance] setBarTintColor:
         [UIColor colorWithRed:104/255.f green:227/255.f blue:68/255.f alpha:1.f]];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor]; // change this color
        n.titleView = label;
        label.text = NSLocalizedString(@"Ocra", @"");
        [label sizeToFit];

        selectedPath = -1;


        [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc]
                                                     initWithImage:[UIImage imageNamed:@"camera-icon"] landscapeImagePhone:[UIImage imageNamed:@"camera-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnToCam:)]];

    }
    return self;
}
-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)updateItemAtIndex:(NSInteger)index andTitle:(NSString *)title andLinks:(NSArray *)linksArray
{
    ListItem *item = [[[ListItemStore sharedStore] allItems] objectAtIndex:index];
    item.text = title;
    item.isLoaded = YES;
    [[(CustomTableViewCell *)[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]] indicator] setHidden:YES];

    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];

    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)updateUnloadedItemWithTitle:(NSString *)title {
    NSLog(@"made it to updateUnloadedItemWithTitle");

    for (ListItem *item in [[ListItemStore sharedStore] allItems]) {
        NSLog(@"item: %@", item);
        if (!item.isLoaded) {
            item.text = title;
            item.isLoaded = YES;
        }
    }

    [self reload];
}

- (void)reload
{
    NSLog(@"reload called");
    [[self tableView] reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ListItemStore sharedStore] allItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = @"myCell";

    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
//        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    cell.centerTitle.text = [(ListItem *)[[[ListItemStore sharedStore] allItems] objectAtIndex:[indexPath row]] text];
    cell.primaryImage.image = [(ListItem *)[[[ListItemStore sharedStore] allItems] objectAtIndex:[indexPath row]] image];
    cell.loadingStatus = [(ListItem *)[[[ListItemStore sharedStore] allItems] objectAtIndex:[indexPath row]] isLoaded];
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[ListItemStore sharedStore] removeItemAtIndex:[indexPath row]];
        [self reload];
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(selectedPath == indexPath.row)
    {
        return 130.f;
    }
    else {
        return 50.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%@", [(ListItem *)[[[ListItemStore sharedStore] allItems] objectAtIndex:[indexPath row]] text]);

    if (selectedPath == indexPath.row) {
        selectedPath = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }

    if (selectedPath >= 0) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForItem:selectedPath inSection:0];
        selectedPath = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];

        return;
    }

    selectedPath = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)returnToCam:(id)sender
{
    [[self delegate] goToCam];
}

@end
