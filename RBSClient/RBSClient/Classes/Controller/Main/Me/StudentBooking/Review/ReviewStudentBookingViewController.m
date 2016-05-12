//
//  ReviewStudentBookingViewController.m
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "ReviewStudentBookingViewController.h"
#import "RoomBooking.h"
#import "SimpleDescriptionCell.h"
#import "TextInputCell.h"
#import "TimeIntervalCell.h"
#import "BookingProgressCell.h"
#import "APIManager.h"

@interface ReviewStudentBookingViewController ()

@property(strong, nonatomic) RoomBooking *roomBooking;

@property (strong, nonatomic) MJRefreshNormalHeader *header;

@end

@implementation ReviewStudentBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)loadData {
    [[APIManager sharedInstance]
     getRoomBookingInfoWithGroupId:self.studentBookingGroupId
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             self.roomBooking = [[RoomBooking alloc]
                                 initWithJsonData:jsonData];
             [self.tableView reloadData];
         } else {
             [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                     fromViewController:self.navigationController];
         }
         
         [self.header endRefreshing];
     }
     failure:^(NSError *error) {
         [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                 fromViewController:self.navigationController];
         
         [self.header endRefreshing];
     }
     timeout:^{
         [UIHelper showTopAlertView:@"等待超时！请稍后重试！"
                 fromViewController:self.navigationController];
         
         [self.header endRefreshing];
     }];
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    // Title.
    self.title = @"审核学生申请";
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleDescriptionCell" bundle:nil]
         forCellReuseIdentifier:@"SimpleDescriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeIntervalCell" bundle:nil]
         forCellReuseIdentifier:@"TimeIntervalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookingProgressCell" bundle:nil]
         forCellReuseIdentifier:@"BookingProgressCell"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectMake(0, 0, 0,
                                                               [GlobalConstants sharedInstance].tabBarHeight)];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
    self.tableView.mj_header = self.header;
    [self.header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.roomBooking) {
        return 0;
    }
    
    // 教室信息
    // 申请进度
    // 提交申请时间
    // 申请人信息
    // 上级信息
    // 管理员信息
    // 申请时间段
    // 失败原因
    if ([self.roomBooking.status containsString:@"拒绝"]) {
        return 8;
    }
    return 7;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        // 教室信息
        case 0: {
            return @"教室信息";
        }
        // 申请进度
        case 1: {
            return @"申请进度";
        }
        // 提交申请时间
        case 2: {
            return @"提交申请时间";
        }
        // 申请人信息
        case 3: {
            return @"申请人信息";
        }
        // 上级信息
        case 4: {
            return @"上级信息";
        }
        // 管理员信息
        case 5: {
            return @"管理员信息";
        }
        // 申请时间段
        case 6: {
            return @"申请时间段";
        }
        // 失败原因
        case 7: {
            return @"教室信息";
        }
            
        default: {
            return nil;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        // 教室信息
        case 0: {
            return 1;
        }
        // 申请进度
        case 1: {
            return self.roomBooking.progresses.count;
        }
        // 提交申请时间
        case 2: {
            return 1;
        }
        // 申请人信息
        case 3: {
            return 1;
        }
        // 上级信息
        case 4: {
            return 1;
        }
        // 管理员信息
        case 5: {
            return 1;
        }
        // 申请时间段
        case 6: {
            return self.roomBooking.timeIntervalList.count;
        }
        // 失败原因
        case 7: {
            return 1;
        }
        
        default: {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // 教室信息
        case 0: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.room];
            
            return cell;
        }
        // 申请进度
        case 1: {
            
            BookingProgressCell *cell = (BookingProgressCell *)[tableView dequeueReusableCellWithIdentifier:@"BookingProgressCell" forIndexPath:indexPath];
            
            NSString *progress = self.roomBooking.progresses[indexPath.row];
            [cell displayProgress:progress];
            
            if (indexPath.row == self.roomBooking.progresses.count - 1 &&
                ![progress containsString:@"拒绝"] &&
                ![progress isEqualToString:@"审核不通过"] &&
                ![progress isEqualToString:@"申请已过期"]) {
                [cell hideProgressImage];
            }
            
            return cell;
        }
        // 提交申请时间
        case 2: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.creationTimeInfo];
            
            return cell;
        }
        // 申请人信息
        case 3: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.applicantInfo];
            
            return cell;
        }
        // 上级信息
        case 4: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.supervisorInfo];
            
            return cell;
        }
        // 管理员信息
        case 5: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.admin];
            
            return cell;
        }
        // 申请时间段
        case 6: {
            TimeIntervalCell *cell = (TimeIntervalCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeIntervalCell"];
            
            TimeInterval *timeInterval = self.roomBooking.timeIntervalList[indexPath.row];
            [cell displayTimeInterval:timeInterval];
            
            return cell;
        }
        // 失败原因
        case 7: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            if (self.roomBooking.declineReason) {
                [cell displayDescription:self.roomBooking.declineReason];
            } else {
                [cell displayDescription:@""];
            }
            
            return cell;
        }
            
        default: {
            return nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 7) {
        [self showDeclinedReason];
    }
}

#pragma mark - Header action

- (void)refresh {
    self.roomBooking = nil;
    [self loadData];
}

#pragma mark - Button action

/**
 *  Show declined reason as modal.
 */
- (void)showDeclinedReason {
    
}

@end
