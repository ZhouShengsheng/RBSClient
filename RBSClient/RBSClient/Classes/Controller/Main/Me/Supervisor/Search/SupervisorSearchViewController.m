//
//  SupervisorSearchViewController.m
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "SupervisorSearchViewController.h"
#import "UserProfileViewController.h"
#import "SupervisorListCell.h"
#import "APIManager.h"
#import "UserManager.h"

@interface SupervisorSearchViewController () <UISearchBarDelegate>

@property(strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray<Faculty *> *supervisorList;
@property (assign, nonatomic) BOOL noMoreData;

@property (strong, nonatomic) MJRefreshNormalHeader *header;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;

@end

@implementation SupervisorSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

/**
 *  Load data from server.
 */
- (void)loadData {
    [[APIManager sharedInstance]
     searchSupervisorWithCondition:self.searchBar.text
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
             [self.supervisorList addObject:[[Faculty alloc] initWithJsonData:array[i]]];
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
    self.title = @"搜索上级";
    
    // Search bar.
    self.searchBar = [[UISearchBar alloc]
                      init];
    self.searchBar.placeholder = @"请输入教职工姓名";
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.showsCancelButton = YES;
    
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    
    id barButtonAppearanceInSearchBar = [UIBarButtonItem
                                         appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButtonAppearanceInSearchBar setTitle:@"取消"];
    
    // Init room list array.
    self.supervisorList = [NSMutableArray array];
    
    // Register table view cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"SupervisorListCell" bundle:nil]
         forCellReuseIdentifier:@"SupervisorListCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Init header and footer.
    self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
    self.tableView.mj_header = self.header;
    
    self.footer = [UIHelper refreshFooterWithTarget:self action:@selector(loadMore)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.supervisorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupervisorListCell *cell = (SupervisorListCell *)[tableView dequeueReusableCellWithIdentifier:@"SupervisorListCell" forIndexPath:indexPath];
    
    [cell displayWithFaculty:self.supervisorList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserProfileViewController *vc = [UserProfileViewController new];
    vc.faculty = self.supervisorList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Header and footer actions

/**
 *  Pull down to refresh.
 */
- (void)refresh {
    self.noMoreData = NO;
    self.tableView.mj_footer = nil;
    
    [self.supervisorList removeAllObjects];
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
