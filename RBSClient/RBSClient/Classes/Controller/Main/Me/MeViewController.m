//
//  MeViewController.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "MeViewController.h"
#import "UserManager.h"
#import "SimpleDescriptionCell.h"
#import "MainController.h"
#import "UserProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "SupervisorListViewController.h"
#import "StudentBookingViewController.h"
#import "DetailedBookingListViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    // Title.
    self.title = [UserManager sharedInstance].userName;
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleDescriptionCell" bundle:nil]
         forCellReuseIdentifier:@"SimpleDescriptionCell"];
    self.tableView.tableFooterView = [UIView new];
    
    // Book button.
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"注销登录"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UserType userType = [UserManager sharedInstance].userType;
    if (userType == USER_TYPE_UNKNOWN) {
        return 0;
    }
    if (userType == USER_TYPE_ADMIN) {
        return 2;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleDescriptionCell *cell = [tableView
                                    dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell"
                                    forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    switch (indexPath.row) {
        case 0: {
            [cell displayDescription:@"个人信息"];
            break;
        }
        case 1: {
            [cell displayDescription:@"修改密码"];
            break;
        }
        case 2: {
            switch ([UserManager sharedInstance].userType) {
                case USER_TYPE_UNKNOWN: {
                    [cell displayDescription:@"上级管理"];
                    break;
                }
                case USER_TYPE_ADMIN: {
                    [cell displayDescription:@"申请审核"];
                    break;
                }
                case USER_TYPE_FACULTY: {
                    [cell displayDescription:@"学生申请审核"];
                    break;
                }
                case USER_TYPE_STUDENT: {
                    [cell displayDescription:@"上级管理"];
                    break;
                }
            }
            break;
        }
        case 3: {
            [cell displayDescription:@"申请历史"];
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        // 个人信息
        case 0: {
            UserProfileViewController *vc = [UserProfileViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        // 修改密码
        case 1: {
            ChangePasswordViewController *vc = [ChangePasswordViewController new];
            [self.navigationController pushViewController:vc animated:YES];
             break;
        }
        // 上级管理/学生申请审核
        case 2: {
            switch ([UserManager sharedInstance].userType) {
                case USER_TYPE_UNKNOWN: {
                    break;
                }
                case USER_TYPE_ADMIN: {
                    break;
                }
                case USER_TYPE_FACULTY: {
                    // 学生申请审核
                    StudentBookingViewController *vc = [StudentBookingViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case USER_TYPE_STUDENT: {
                    // 上级管理
                    SupervisorListViewController *vc = [SupervisorListViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
            }
            break;
        }
        // 申请历史
        case 3: {
            DetailedBookingListViewController *vc = [DetailedBookingListViewController new];
            vc.title = @"申请历史";
            vc.bookingType = BOOKING_TYPE_HISTORY;
            vc.parentNavigationController = self.navigationController;
            vc.willAutoLoadData = YES;
            [self.navigationController pushViewController:vc animated:YES];
            // Send local notification.
            UILocalNotification* local = [[UILocalNotification alloc] init];
            if (local)
            {
                local.fireDate = [NSDate new];
                local.alertBody = @"Hey this is my first local notification!!!";
                local.timeZone = [NSTimeZone defaultTimeZone];
                [[UIApplication sharedApplication] scheduleLocalNotification:local];
            }
        }
    }
}

#pragma mark - Logout

- (void)logout {
    PopupView *logoutPopup = [UIHelper popupViewWithMessage:@"是否确认注销登录？"];
    logoutPopup.confirmButtonPressedBlock = ^(void) {
        [[UserManager sharedInstance] logout];
    };
}

@end
