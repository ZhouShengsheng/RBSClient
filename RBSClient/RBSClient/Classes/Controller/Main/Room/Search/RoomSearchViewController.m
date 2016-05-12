//
//  RoomSearchViewController.m
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomSearchViewController.h"
#import "APIManager.h"
#import "RoomListCell.h"
#import "RoomInfoViewController.h"

@interface RoomSearchViewController () <UISearchBarDelegate>

@property(strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) MJRefreshNormalHeader *header;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;

@property (strong, nonatomic) NSMutableArray<Room *> *roomList;
@property (assign, nonatomic) BOOL noMoreData;

@end

@implementation RoomSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

/**
 *  Load data from server.
 */
- (void)loadData {
    [[APIManager sharedInstance]
     searchRoomListWithCondition:self.searchBar.text
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             [self.header endRefreshing];
             [self.footer endRefreshing];
             return ;
         }
         NSArray *array = (NSArray *)jsonData;
         NSUInteger count = array.count;
         if (count < defaultPageSize) {
             self.noMoreData = YES;
             [self.footer endRefreshingWithNoMoreData];
         } else {
             [self.footer endRefreshing];
         }
         for (NSUInteger i = 0; i < count; i++) {
             [self.roomList addObject:[[Room alloc] initWithJsonData:array[i]]];
         }
         [self.tableView reloadData];
         [self.header endRefreshing];
         self.tableView.mj_footer = self.footer;
     }
     failure:^(NSError *error) {
         [self.header endRefreshing];
         [self.footer endRefreshing];
     }
     timeout:^{
         [self.header endRefreshing];
         [self.footer endRefreshing];
     }];
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    self.title = @"搜索教室";
    
    // Search bar.
    self.searchBar = [[UISearchBar alloc]
                      init];
    self.searchBar.placeholder = @"请输入教室楼栋或编号";
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.showsCancelButton = YES;
    
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    
    id barButtonAppearanceInSearchBar = [UIBarButtonItem
                                         appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButtonAppearanceInSearchBar setTitle:@"取消"];
    
    // Init room list array.
    self.roomList = [NSMutableArray array];
    
    // Register table view cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"RoomListCell" bundle:nil]
         forCellReuseIdentifier:@"RoomListCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Init header and footer.
    self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
    self.tableView.mj_header = self.header;
    
    self.footer = [UIHelper refreshFooterWithTarget:self action:@selector(loadMore)];
}

#pragma mark - Header and footer actions
/**
 *  Pull down to refresh.
 */
- (void)refresh {
    self.noMoreData = NO;
    self.tableView.mj_footer = nil;
    
    [self.roomList removeAllObjects];
    [self.tableView reloadData];
    
    // Load data from server.
    [self loadData];
}

/**
 *  Load more.
 */
- (void)loadMore {
    if (self.noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomListCell *cell = (RoomListCell *)[tableView dequeueReusableCellWithIdentifier:@"RoomListCell"
                                                                         forIndexPath:indexPath];
    
    [cell displayWithRoom:self.roomList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Room *room = self.roomList[indexPath.row];
    RoomInfoViewController *vc = [RoomInfoViewController new];
    vc.building = room.building;
    vc.number = room.number;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    DDLogError(@"%s", __func__);
    DDLogError(@"searchCondition: %@", searchBar.text);
    [searchBar resignFirstResponder];
    [self.header beginRefreshing];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


@end
