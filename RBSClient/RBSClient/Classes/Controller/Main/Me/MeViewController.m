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
#import "NotificationBadgeController.h"
#import "PushNotificationManager.h"
#import "APIManager.h"
#import "AppDelegate.h"

@interface MeViewController ()

@property(strong, nonatomic) SSBadgeController *studentBookingBadageController;

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
                    if (!self.studentBookingBadageController) {
                        self.studentBookingBadageController = [[SSBadgeController alloc] init];
                        self.studentBookingBadageController.layer = cell.layer;
                        UIOffset offset = {-50, 20};
                        self.studentBookingBadageController.badgePositionAdjustment = offset;
                        [self addBadgeNotificationObserver];
                    }
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
        }
    }
}

#pragma mark - Logout

- (void)logout {
    PopupView *logoutPopup = [UIHelper popupViewWithMessage:@"是否确认注销登录？"];
    logoutPopup.confirmButtonPressedBlock = ^(void) {
        MBProgressHUD *hud =
        [UIHelper showProcessingHUDWithMessage:@"正在注销登录"
                                   addedToView:[AppDelegate delegate].window.rootViewController.view];
        
        UserManager *userManager = [UserManager sharedInstance];
        [[APIManager sharedInstance]
         logoutWithType:userManager.userTypeStr
         userId:userManager.userId
         success:^(id jsonData) {
             if ([jsonData isKindOfClass:NSDictionary.class]) {
                 NSString *message = jsonData[@"message"];
                 if ([message isEqualToString:@"Logged out."]) {
                     [[UserManager sharedInstance] logout];
                 } else {
                     [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
                 }
             }
             [[UserManager sharedInstance] logout];
             [hud hide:YES];
         }
         failure:^(NSError *error) {
             [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
             [hud hide:YES];
         }
         timeout:^{
             [UIHelper showTimeoutAlertViewWithViewController:self.navigationController];
             [hud hide:YES];
         }];
        
    };
}

#pragma mark - Badge notification methods

/**
 *  Badge notification name for student booking cell.
 */
- (NSString *)notificationNameForStudentBooking {
    return PushNotificationMeStudentBookingNotification;
}

/**
 *  Add observer for badge notification.
 */
- (void)addBadgeNotificationObserver {
    if ([UserManager sharedInstance].userType == USER_TYPE_FACULTY) {
        // add notification observer
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(observeBadgeNotification:)
         name:[self notificationNameForStudentBooking]
         object:[NotificationBadgeController sharedInstance]];
        
        // check badge value
        NSUInteger processingBadgeValue =
        [[NotificationBadgeController sharedInstance]
         valueForBadgeWithBadgeName:[self notificationNameForStudentBooking]];
        if (processingBadgeValue > 0) {
            [self setBadgeWithName:[self notificationNameForStudentBooking]
                        badgeValue:processingBadgeValue];
        }
    }
}

/**
 *  Observe badge notification.
 */
- (void)observeBadgeNotification:(NSNotification *)notification {
    NotificationBadgeObject *badge = [notification userInfo][BadgeUserInfoKey];
    DDLogWarn(@"received badge object: %@", badge);
    [self setBadgeWithName:badge.name badgeValue:badge.value];
}

/**
 *  Add badge.
 */
- (void)setBadgeWithName:(NSString *)badgeName badgeValue:(NSUInteger)badgeValue {
    SSBadgeController *badageController = nil;
    if ([badgeName isEqualToString:[self notificationNameForStudentBooking]]) {
        badageController = self.studentBookingBadageController;
    }
    
    if (badageController) {
        if (badgeValue > 0) {
            badageController.badgeValue = [@(badgeValue) stringValue];
            badageController.animated = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                badageController.animated = NO;
            });
        } else {
            badageController.badgeValue = nil;
        }
    }
}

@end
