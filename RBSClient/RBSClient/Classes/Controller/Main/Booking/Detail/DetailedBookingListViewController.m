//
//  DetailedBookingListViewController.m
//  RBSClient
//
//  Created by Shengsheng on 13/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "DetailedBookingListViewController.h"
#import "APIManager.h"
#import "UserManager.h"
#import "RoomBooking.h"
#import "BookingListCell.h"
#import "ReviewStudentBookingViewController.h"
#import "NotificationBadgeController.h"

@interface DetailedBookingListViewController ()

@property (strong, nonatomic) NSMutableArray<RoomBooking *> *roomBookingList;
@property (assign, nonatomic) BOOL noMoreData;

@property (strong, nonatomic) MJRefreshNormalHeader *header;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;

@end

@implementation DetailedBookingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    if (self.willAutoLoadData) {
        [self initializeView];
    }
}

/**
 *  Load data from server.
 */
- (void)loadData {
    // Success block.
    void(^successBlock)(id jsonData) = ^(id jsonData){
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
            [self.roomBookingList addObject:[[RoomBooking alloc] initWithJsonData:array[i]]];
        }
        [self.tableView reloadData];
        [self.header endRefreshing];
        self.tableView.mj_footer = self.footer;
        
        // Clear notification badage.
        [[NotificationBadgeController sharedInstance]
         clearValueWithBadgeName:[self notificationName]];
    };
    
    // Error block.
    void (^errorBlock)(NSError *error) = ^(NSError *error){
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
    };
    
    // Timeout block.
    void (^timeoutBlock)(void) = ^{
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [UIHelper showTimeoutAlertViewWithViewController:self.navigationController];
    };
    
    switch (self.bookingType) {
        // These four are for users.
        // Processing list.
        case BOOKING_TYPE_PROCESSING: {
            UserManager *userManager = [UserManager sharedInstance];
            [[APIManager sharedInstance]
             getProcessingRoomBookingListWithApplicantType:userManager.userTypeStr
             applicantId:userManager.userId
             fromIndex:self.roomBookingList.count
             success:successBlock
             failure:errorBlock
             timeout:timeoutBlock];
            break;
        }
        // Approved list.
        case BOOKING_TYPE_APPROVED: {
            UserManager *userManager = [UserManager sharedInstance];
            [[APIManager sharedInstance]
             getApprovedRoomBookingListWithApplicantType:userManager.userTypeStr
             applicantId:userManager.userId
             fromIndex:self.roomBookingList.count
             success:successBlock
             failure:errorBlock
             timeout:timeoutBlock];
            break;
        }
        // Declined list.
        case BOOKING_TYPE_DECLINED: {
            UserManager *userManager = [UserManager sharedInstance];
            [[APIManager sharedInstance]
             getDeclinedRoomBookingListWithApplicantType:userManager.userTypeStr
             applicantId:userManager.userId
             fromIndex:self.roomBookingList.count
             success:successBlock
             failure:errorBlock
             timeout:timeoutBlock];
            break;
        }
        // History list.
        case BOOKING_TYPE_HISTORY: {
            UserManager *userManager = [UserManager sharedInstance];
            [[APIManager sharedInstance]
             getHistoryRoomBookingListWithApplicantType:userManager.userTypeStr
             applicantId:userManager.userId
             fromIndex:self.roomBookingList.count
             success:successBlock
             failure:errorBlock
             timeout:timeoutBlock];
            break;
        }
        // These two are for admin.
        // Processing list.
        case BOOKING_TYPE_ADMIN_PROCESSING: {
            [[APIManager sharedInstance]
             getAdminRoomBookingProcessingListWithFromIndex:self.roomBookingList.count
             success:successBlock
             failure:errorBlock
             timeout:timeoutBlock];
            break;
        }
        // Processed list.
        case BOOKING_TYPE_ADMIN_PROCCESSED: {
            [[APIManager sharedInstance]
             getAdminRoomBookingProcessedListWithFromIndex:self.roomBookingList.count
             success:successBlock
             failure:errorBlock
             timeout:timeoutBlock];
            break;
        }
    }
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    if (!self.roomBookingList) {
        // Init room booking list array.
        self.roomBookingList = [NSMutableArray array];
        
        // Register table view cell.
        [self.tableView registerNib:[UINib nibWithNibName:@"BookingListCell" bundle:nil]
             forCellReuseIdentifier:@"BookingListCell"];
        GlobalConstants *consts = [GlobalConstants sharedInstance];
        self.tableView.top = consts.statusHeight + consts.navigationBarHeight;
        self.tableView.height = consts.screenHeight - self.tableView.top;
        
        // Init header and footer.
        self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
        self.tableView.mj_header = self.header;
        
        self.footer = [UIHelper refreshFooterWithTarget:self action:@selector(loadMore)];
        [self.header beginRefreshing];
    }
}

- (UIScrollView *)currentScrollView {
    return self.tableView;
}

- (void)reloadData {
    [self.header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomBookingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookingListCell *cell = (BookingListCell *)[tableView
                                                      dequeueReusableCellWithIdentifier:@"BookingListCell"
                                                      forIndexPath:indexPath];
    [cell displayWithRoomBooking:self.roomBookingList[indexPath.row]];
    // Hide progress when it's in admin processing list.
    if (self.bookingType == BOOKING_TYPE_ADMIN_PROCESSING) {
        cell.progressLabel.text = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Enter detailed room booking view.
    ReviewStudentBookingViewController *vc = [ReviewStudentBookingViewController new];
    vc.studentBookingGroupId = self.roomBookingList[indexPath.row].groupId;
    [self.parentNavigationController pushViewController:vc animated:YES];
}

#pragma mark - Header and footer actions

/**
 *  Pull down to refresh.
 */
- (void)refresh {
    self.noMoreData = NO;
    self.tableView.mj_footer = nil;
    
    [self.roomBookingList removeAllObjects];
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
    switch (self.bookingType) {
        case BOOKING_TYPE_PROCESSING: {
            return PushNotificationBookingProcessingNotification;
        }
        case BOOKING_TYPE_APPROVED: {
            return PushNotificationBookingSucceedNotification;
        }
        case BOOKING_TYPE_DECLINED: {
            return PushNotificationBookingFailedNotification;
        }
        
        default: {
            return nil;
        }
    }
}

@end
