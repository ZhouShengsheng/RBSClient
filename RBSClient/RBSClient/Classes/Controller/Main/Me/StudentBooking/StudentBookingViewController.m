//
//  StudentBookingViewController.m
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "StudentBookingViewController.h"
#import "APIManager.h"
#import "UserManager.h"
#import "StudentBooking.h"
#import "StudentBookingCell.h"
#import "ReviewStudentBookingViewController.h"
#import "NotificationBadgeController.h"

@interface StudentBookingViewController ()

@property (strong, nonatomic) NSMutableArray<StudentBooking *> *studentBookingList;
@property (assign, nonatomic) BOOL noMoreData;

@property (strong, nonatomic) MJRefreshNormalHeader *header;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;

@end

@implementation StudentBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    if (self.header) {
        [self.header beginRefreshing];
    }
}

/**
 *  Load data from server.
 */
- (void)loadData {
    [[APIManager sharedInstance]
     getStudentBookingWithFacultyId:[UserManager sharedInstance].userId
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
             [self.studentBookingList addObject:[[StudentBooking alloc] initWithJsonData:array[i]]];
         }
         [self.tableView reloadData];
         [self.header endRefreshing];
         self.tableView.mj_footer = self.footer;
         
         // Clear notification badage.
         [[NotificationBadgeController sharedInstance]
          clearValueWithBadgeName:[self notificationName]];
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
    // Title.
    self.title = @"学生申请列表";
    
    // Init supervisor list array.
    self.studentBookingList = [NSMutableArray array];
    
    // Register table view cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentBookingCell" bundle:nil]
         forCellReuseIdentifier:@"StudentBookingCell"];
    self.tableView.tableFooterView = [UIView new];
    
    // Init header and footer.
    self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
    self.tableView.mj_header = self.header;
    
    self.footer = [UIHelper refreshFooterWithTarget:self action:@selector(loadMore)];
    //[self.header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.studentBookingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentBookingCell *cell = (StudentBookingCell *)[tableView
                                                      dequeueReusableCellWithIdentifier:@"StudentBookingCell"
                                                      forIndexPath:indexPath];
    [cell displayWithStudentBooking:self.studentBookingList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Enter detailed room booking view.
    ReviewStudentBookingViewController *vc = [ReviewStudentBookingViewController new];
    vc.studentBookingGroupId = self.studentBookingList[indexPath.row].groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Header and footer actions

/**
 *  Pull down to refresh.
 */
- (void)refresh {
    self.noMoreData = NO;
    self.tableView.mj_footer = nil;
    
    [self.studentBookingList removeAllObjects];
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

/**
 *  Notification name.
 */
- (NSString *)notificationName {
    return PushNotificationMeStudentBookingNotification;
}

@end
