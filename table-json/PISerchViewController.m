//
//  PISerchViewController.m
//  table-json
//
//  Created by Maxim Berezhnoy on 10.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PISerchViewController.h"
#import "PIDataProvider.h"
#import "PIPostTableCell.h"
#import "PINetImageView.h"


@interface PISerchViewController ()

@end

@implementation PISerchViewController {
    PIDataProvider * dataProvider;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loading.animationImages = [PINetImageView getLoadingFrames];
    _loading.animationDuration = 1;
    [self showLoading:YES withAnimation:NO];

    self.searchDisplayController.searchResultsTableView.rowHeight = _tableView.rowHeight;

    
    dataProvider = [[PIDataProvider alloc] init];
    [dataProvider onLoadNotifyObject:self withSelector:@selector(onDataLoad:)];
    [dataProvider startRequest];
}

- (void)showLoading:(BOOL)isLoading withAnimation:(BOOL)isAnimated
{
    UITableView * stbl = self.searchDisplayController.searchResultsTableView;
    CGFloat loadAlpha = isLoading ? 1 : 0;

//    NSLog(@"showLoading %d %d", isLoading, isAnimated);
    if(isAnimated)
    {
        _loading.hidden = NO;
        _tableView.hidden = NO;
        if ( _tableView != stbl) stbl.hidden = NO;

        [UIView animateWithDuration:0.5 delay:0
                options:UIViewAnimationOptionCurveEaseInOut
                animations:^{
                    _loading.alpha = loadAlpha;
                    _tableView.alpha = 1-loadAlpha;
                    stbl.alpha = 1-loadAlpha;
                }
                completion:^(BOOL finished){
                    //if(!finished) return ;
                    _loading.hidden = !isLoading;
                    _tableView.hidden = isLoading;
                    stbl.hidden = isLoading;
                    if (isLoading)
                    {
                        [_loading startAnimating];
                    }else
                    {
                        [_loading stopAnimating];
                    }
                }];
    }else
    {
        _loading.hidden = !isLoading;
        _tableView.hidden = isLoading;
        stbl.hidden = isLoading;

        _loading.alpha = loadAlpha;
        _tableView.alpha = 1-loadAlpha;
        stbl.alpha = 1-loadAlpha;
        
        if (isLoading)
        {
            [_loading startAnimating];
        }else
        {
            [_loading stopAnimating];
        }
    }
    
}

- (void)onDataLoad:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [self.searchDisplayController.searchResultsTableView reloadData];
        [self showLoading:NO withAnimation:YES];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"data size: %d", dataProvider.size);
    return dataProvider.size;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cid = @"post-default";
    PIPostTableCell * cell = [tableView dequeueReusableCellWithIdentifier: cid];
    if ( cell==nil)
    {
        cell = [_tableView dequeueReusableCellWithIdentifier: cid];
    }
    
    PIPostItem * post = [dataProvider getItem:indexPath.row];
    
    cell.postTitle.text = post.title;
    cell.postContent.text = post.text;
    cell.postImage.imgUrl = post.thumb;
    
    return cell;
}

- (void)onSearchTextChanged:(NSString*)searchText
{
    dataProvider.searchString = searchText;
    [self showLoading:YES withAnimation:YES];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //NSLog(@"all removed");
    [self onSearchTextChanged:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self onSearchTextChanged:searchBar.text];
    //NSLog(@"click search for: %@", searchBar.text);
}

@end
