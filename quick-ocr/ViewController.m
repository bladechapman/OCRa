//
//  ViewController.m
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import "ViewController.h"
#import "CamViewController.h"
#import "ListViewController.h"
#import "ListItemStore.h"
#import "ListItem.h"
#import "CustomScrollView.h"

@interface ViewController ()

@property CustomScrollView* scrollView;
@property CamViewController *camViewController;
@property ListViewController *listViewController;
@property UINavigationController *listNavigator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    CGRect screenSize = self.view.frame;
    _scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(screenSize.origin.x,
                                                                 screenSize.origin.y,
                                                                 screenSize.size.width,
                                                                 screenSize.size.height)];
    [_scrollView setDelegate:self];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = NO;

    _scrollView.canCancelContentTouches = YES;
    _scrollView.delaysContentTouches = NO;

    [_scrollView setContentSize:CGSizeMake(screenSize.size.width * 2, screenSize.size.height)];


    _camViewController = [[CamViewController alloc] init];
    [_camViewController setDelegate:self];
    [_camViewController.view setFrame:CGRectMake(screenSize.origin.x, screenSize.origin.y, screenSize.size.width, screenSize.size.height)];

    _listViewController = [[ListViewController alloc] init];
    [_listViewController setDelegate:self];
    _listNavigator = [[UINavigationController alloc] initWithRootViewController:_listViewController];
    [[_listNavigator view] setFrame:CGRectMake(screenSize.size.width, screenSize.origin.y, screenSize.size.width, screenSize.size.height)];



    [_scrollView addSubview:[_camViewController view]];
    [_scrollView addSubview:[_listNavigator view]];

    [[self view] addSubview:_scrollView];
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [_camViewController view];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - Cam Delegate
- (void)imageCaptured:(UIImage *)image {
//    NSLog(@"image picked");
    ListItem *listItem = [[ListItem alloc] initWithImage:image andLoaded:NO andText:nil];
    [[ListItemStore sharedStore] addItem:listItem];
    [_listViewController reload];

    [_scrollView setContentOffset: CGPointMake(_scrollView.contentOffset.x + self.view.frame.size.width,
                                               _scrollView.contentOffset.y) animated:YES];
}
- (void)dataReceived:(NSData *)data {
//    NSLog(@"data received\n%@", data);

    NSLog(@"fdsafsa");
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"%@", array);

    if ([array count] >= 1) {
        NSLog(@"inside array");
        NSDictionary *dict = [array objectAtIndex:0];
        NSLog(@"dict: %@", dict);

        
        [_listViewController updateUnloadedItemWithTitle:[dict objectForKey:@"title"]];
    }


    //should call listview's:
    //- (void)updateItemAtIndex:(NSInteger)index andTitle:(NSString *)title andLinks:(NSArray *)linksArray
    //reload all listViewItems?

    
}

#pragma mark - List Delegate
- (void)goToCam {
    [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y) animated:YES];
}



@end
