//
//  SupervisorListViewController.m
//  RBSClient
//
//  Created by Shengsheng on 11/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "SupervisorListViewController.h"
#import "UserProfileViewController.h"
#import "SupervisorSearchViewController.h"
#import "SupervisorListCell.h"
#import "APIManager.h"
#import "UserManager.h"

@interface SupervisorListViewController ()

@property (strong, nonatomic) NSMutableArray<Faculty *> *supervisorList;
@property (assign, nonatomic) BOOL noMoreData;

@property (strong, nonatomic) MJRefreshNormalHeader *header;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;

@end

@implementation SupervisorListViewController

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
     getSupervisorListWithStudentId:[UserManager sharedInstance].userId
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             [self.header endRefreshing];
             [self.footer endRefreshing];
             [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
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
         [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
     }
     timeout:^{
         [self.header endRefreshing];
         [self.footer endRefreshing];
         [UIHelper showTimeoutAlertViewWithViewController:self.navigationController];
     }];
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    // Title.
    self.title = @"上级列表";
    
    // Navigation bar buttons.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"添加"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(addSupervisor)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Init supervisor list array.
    self.supervisorList = [NSMutableArray array];
    
    // Register table view cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"SupervisorListCell" bundle:nil]
         forCellReuseIdentifier:@"SupervisorListCell"];
    self.tableView.tableFooterView = [UIView new];
    
    // Init header and footer.
    self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
    self.tableView.mj_header = self.header;
    
    self.footer = [UIHelper refreshFooterWithTarget:self action:@selector(loadMore)];
    [self.header beginRefreshing];
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
    if (self.willSelectSupervisor) {
        Faculty *supervisor = self.supervisorList[indexPath.row];
        [UserManager sharedInstance].selectedSupervisor = supervisor;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UserProfileViewController *vc = [UserProfileViewController new];
        vc.faculty = self.supervisorList[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
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

#pragma mark - Button actions

/**
 *  Add supervisor.
 */
- (void)addSupervisor {
    SupervisorSearchViewController *vc = [SupervisorSearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
