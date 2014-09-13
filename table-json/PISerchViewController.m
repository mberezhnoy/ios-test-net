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


@interface PISerchViewController ()

@end

@implementation PISerchViewController {
    PIDataProvider * dataProvider;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.hidden = true;
    self.searchDisplayController.searchResultsTableView.rowHeight = _tableView.rowHeight;

    
    dataProvider = [[PIDataProvider alloc] init];
    [dataProvider onLoadNotifyObject:self withSelector:@selector(onDataLoad:)];
    [dataProvider startRequest];
}

- (void)onDataLoad:(id)sender
{
    _loadingLable.hidden = true;
    _tableView.hidden = false;
    if ( _tableView != self.searchDisplayController.searchResultsTableView)
    {
        self.searchDisplayController.searchResultsTableView.hidden = false;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [self.searchDisplayController.searchResultsTableView reloadData];
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
    _tableView.hidden = true;
    _loadingLable.hidden = false;
    if ( _tableView != self.searchDisplayController.searchResultsTableView)
    {
        self.searchDisplayController.searchResultsTableView.hidden = true;
    }

//    NSLog(@"%@  %@", searchText, scope);
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
