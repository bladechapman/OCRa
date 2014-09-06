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

@interface ListViewController ()

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

        self.tableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ITc3qFX"]];

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
    //check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];

    //If there is no reusable cell of this type, create a new one
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }

    ListItem *item = [[[ListItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item text]];

    [[cell imageView] setImage:[self imageByCroppingImage:[item image] toSize:CGSizeMake(30, 30)]];
    [cell imageView].layer.cornerRadius = 15;
    [cell imageView].layer.masksToBounds = YES;
    NSLog(@"%@", [item text]);

    // Configure the cell...
    
    return cell;
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    double x = (image.size.width - size.width) / 2.0;
    double y = (image.size.height - size.height) / 2.0;

    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);

    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return cropped;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", [(ListItem *)[[[ListItemStore sharedStore] allItems] objectAtIndex:[indexPath row]] text]);
}

- (void)returnToCam:(id)sender
{
    NSLog(@"fdsafasd");
    [[self delegate] goToCam];
}

@end
