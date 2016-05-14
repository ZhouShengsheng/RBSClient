//
//  ReviewStudentBookingViewController.m
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "ReviewStudentBookingViewController.h"
#import "SimpleDescriptionCell.h"
#import "TextInputCell.h"
#import "TimeIntervalCell.h"
#import "BookingProgressCell.h"
#import "APIManager.h"
#import "UserManager.h"
#import "DeclineViewController.h"
#import "RoomBookingViewController.h"
#import "CredentialViewController.h"

@interface ReviewStudentBookingViewController ()

@property(strong, nonatomic) RoomBooking *roomBooking;

@property(strong, nonatomic) MJRefreshNormalHeader *header;

// Approve and decline.
@property(strong, nonatomic) UIButton *declineButton;
@property(strong, nonatomic) UIButton *approveButton;
@property(strong, nonatomic) UIView *approveDeclineToolbarView;

// Cancel and rebook.
@property(strong, nonatomic) UIButton *cancelButton;
@property(strong, nonatomic) UIButton *rebookButton;
@property(strong, nonatomic) UIView *cancelOrRebookToolbarView;

@end

@implementation ReviewStudentBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self.tableView reloadData];
    if (self.roomBooking) {
        [self showAndEnableToolbar];
    } else {
        [self hideAndDisableToolbar];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.tableView reloadData];
    [self hideAndDisableToolbar];
}

- (void)loadData {
    [[APIManager sharedInstance]
     getRoomBookingInfoWithGroupId:self.studentBookingGroupId
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             self.roomBooking = [[RoomBooking alloc]
                                 initWithJsonData:jsonData];
             [self.tableView reloadData];
             [self showAndEnableToolbar];
             [self addCredentialButton];
             
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
    self.title = @"申请详情";
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleDescriptionCell" bundle:nil]
         forCellReuseIdentifier:@"SimpleDescriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeIntervalCell" bundle:nil]
         forCellReuseIdentifier:@"TimeIntervalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookingProgressCell" bundle:nil]
         forCellReuseIdentifier:@"BookingProgressCell"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [UIHelper configureTableFooterView:self.tableView];
    
    [self addToolbar];
    
    self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
    self.tableView.mj_header = self.header;
    [self.header beginRefreshing];
}

- (void)addCredentialButton {
    if ([self.roomBooking.status isEqualToString:@"admin_approved"]) {
        UIBarButtonItem *credentialButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@"电子凭证"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(showCredential)];
        self.navigationItem.rightBarButtonItem = credentialButton;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.roomBooking) {
        return 0;
    }
    
    // 教室信息
    // 申请人信息
    // 申请进度
    // 申请事由
    // 提交申请时间
    // 上级信息
    // 管理员信息
    // 申请时间段
    // 失败原因
    if ([self.roomBooking.status containsString:@"declined"]) {
        return 9;
    }
    return 8;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        // 教室信息
        case 0: {
            return @"教室信息";
        }
        // 申请人信息
        case 1: {
            return @"申请人信息";
        }
        // 申请进度
        case 2: {
            return @"申请进度";
        }
        // 申请事由
        case 3: {
            return @"申请事由";
        }
        // 提交申请时间
        case 4: {
            return @"提交申请时间";
        }
        // 上级信息
        case 5: {
            return @"上级信息";
        }
        // 管理员信息
        case 6: {
            return @"管理员信息";
        }
        // 申请时间段
        case 7: {
            return @"申请时间段";
        }
        // 失败原因
        case 8: {
            return @"失败原因";
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
        // 申请人信息
        case 1: {
            return 1;
        }
        // 申请进度
        case 2: {
            return self.roomBooking.progresses.count;
        }
        // 申请事由
        case 3: {
            return 1;
        }
        // 提交申请时间
        case 4: {
            return 1;
        }
        // 上级信息
        case 5: {
            return 1;
        }
        // 管理员信息
        case 6: {
            return 1;
        }
        // 申请时间段
        case 7: {
            return self.roomBooking.timeIntervalList.count;
        }
        // 失败原因
        case 8: {
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
        // 申请人信息
        case 1: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.applicantInfo];
            
            return cell;
        }
        // 申请进度
        case 2: {
            
            BookingProgressCell *cell = (BookingProgressCell *)[tableView dequeueReusableCellWithIdentifier:@"BookingProgressCell" forIndexPath:indexPath];
            
            NSString *progress = self.roomBooking.progresses[indexPath.row];
            [cell displayProgress:progress];
            
            if (indexPath.row == self.roomBooking.progresses.count - 1 &&
                [progress containsString:@"审核中"]) {
                [cell setProcessImageHidden:YES];
            } else {
                [cell setProcessImageHidden:NO];
            }
            
            return cell;
        }
        // 申请事由
        case 3: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.bookReason];
            
            return cell;
        }
        // 提交申请时间
        case 4: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.creationTimeInfo];
            
            return cell;
        }
        // 上级信息
        case 5: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.supervisorInfo];
            
            return cell;
        }
        // 管理员信息
        case 6: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.admin];
            
            return cell;
        }
        // 申请时间段
        case 7: {
            TimeIntervalCell *cell = (TimeIntervalCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeIntervalCell"];
            
            TimeInterval *timeInterval = self.roomBooking.timeIntervalList[indexPath.row];
            [cell displayTimeInterval:timeInterval];
            
            return cell;
        }
        // 失败原因
        case 8: {
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
    if (indexPath.section == 3) {
        [UIHelper
         showAlertViewWithTitle:@"申请事由"
         message:self.roomBooking.bookReason
         inViewController:self.navigationController];
    } else if (indexPath.section == 8) {
        [UIHelper
         showAlertViewWithTitle:@"失败原因"
         message:self.roomBooking.declineReason
         inViewController:self.navigationController];
    }
}

#pragma mark - Header action

- (void)refresh {
    self.roomBooking = nil;
    [self disableApproveDeclineToolbar];
    [self hideApproveDeclineToolbar];
    [self loadData];
}

#pragma mark - Toolbar

- (void)addToolbar {
    if (![self willNotShowApproveDeclineToolbar]) {
        [self addApproveDeclineToolbar];
    } else {
        [self addCancelOrRebookToolbar];
    }
}

- (void)showAndEnableToolbar {
    if (![self willNotShowApproveDeclineToolbar]) {
        [self showApproveDeclineToolbar];
        [self enableApproveDeclineToolbar];
    } else {
        [self showCancelOrRebookToolbar];
        [self enableCancelOrRebookToolbar];
    }
}

- (void)hideAndDisableToolbar {
    if (![self willNotShowApproveDeclineToolbar]) {
        [self hideApproveDeclineToolbar];
        [self disableApproveDeclineToolbar];
    } else {
        [self hideCancelOrRebookToolbar];
        [self disableCancelOrRebookToolbar];
    }
}

#pragma mark - Approve and decline toolbar

/**
 *  Check if it's needed to show approve and decline toolbar.
 */
- (BOOL)willNotShowApproveDeclineToolbar {
    if ([self.roomBooking.status isEqualToString:@"canceled"]) {
        return YES;
    }
    
    if ([self.roomBooking.status isEqualToString:@"expired"]) {
        return YES;
    }
    
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.userType == USER_TYPE_STUDENT) {
        return YES;
    }
    
    if (userManager.userType == USER_TYPE_FACULTY) {
        if ([self.roomBooking.status isEqualToString:@"faculty_declined"]) {
            return YES;
        }
        if ([self.roomBooking.status isEqualToString:@"faculty_approved"]) {
            return YES;
        }
        if ([self.roomBooking.status isEqualToString:@"admin_declined"]) {
            return YES;
        }
        if ([self.roomBooking.status isEqualToString:@"admin_approved"]) {
            return YES;
        }
    }
    
    if (userManager.userType == USER_TYPE_ADMIN) {
        if ([self.roomBooking.status isEqualToString:@"admin_declined"]) {
            return YES;
        }
        if ([self.roomBooking.status isEqualToString:@"admin_approved"]) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  Add approve and decline toolbar.
 */
-(void)addApproveDeclineToolbar
{
    if ([self willNotShowApproveDeclineToolbar]) {
        return ;
    }
    
    UIView *approveDeclineToolbarView = [UIHelper toolbarView];
    approveDeclineToolbarView.top = [GlobalConstants sharedInstance].screenHeight;
    [self.navigationController.view addSubview:approveDeclineToolbarView];
    
    // Decline button.
    GlobalConstants *consts = [GlobalConstants sharedInstance];
    UIButton *declineButton = [UIButton buttonWithType:UIButtonTypeSystem];
    declineButton.width = roundf(consts.screenWidth / 2);
    declineButton.height = consts.tabBarHeight;
    declineButton.enabled = NO;
    declineButton.titleLabel.font = [UIFont buttonFont];
    [declineButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [declineButton setTitleColor:[UIColor alertColor] forState:UIControlStateNormal];
    //declineButton.backgroundColor = [UIColor alertColor];
    [declineButton addTarget:self
                      action:@selector(decline)
            forControlEvents:UIControlEventTouchUpInside];
    [approveDeclineToolbarView addSubview:declineButton];
    self.declineButton = declineButton;
    
    // Aprove button.
    UIButton *approveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    approveButton.width = roundf(consts.screenWidth / 2);
    approveButton.height = consts.tabBarHeight;
    approveButton.left = declineButton.width;
    approveButton.enabled = NO;
    approveButton.titleLabel.font = [UIFont buttonFont];
    [approveButton setTitle:@"同意" forState:UIControlStateNormal];
    [approveButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    //approveButton.backgroundColor = [UIColor themeColor];
    [approveButton addTarget:self
                      action:@selector(approve)
            forControlEvents:UIControlEventTouchUpInside];
    [approveDeclineToolbarView addSubview:approveButton];
    self.approveButton = approveButton;
    
    self.approveDeclineToolbarView = approveDeclineToolbarView;
    [self disableApproveDeclineToolbar];
}

- (void)showApproveDeclineToolbar {
    if ([self willNotShowApproveDeclineToolbar]) {
        return ;
    }
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.approveDeclineToolbarView.top =
                         [GlobalConstants sharedInstance].screenHeight - self.approveDeclineToolbarView.height;
                     }];
}

- (void)hideApproveDeclineToolbar {
    if ([self willNotShowApproveDeclineToolbar]) {
        return ;
    }
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.approveDeclineToolbarView.top =
                         [GlobalConstants sharedInstance].screenHeight;
                     }];
}

- (void)enableApproveDeclineToolbar {
    if ([self willNotShowApproveDeclineToolbar]) {
        return ;
    }
    
    self.approveButton.enabled = YES;
    self.declineButton.enabled = YES;
}

- (void)disableApproveDeclineToolbar {
    if ([self willNotShowApproveDeclineToolbar]) {
        return ;
    }
    
    self.approveButton.enabled = NO;
    self.declineButton.enabled = NO;
}

#pragma mark - Cancel or rebook toolbar

/**
 *  Check if it's needed to show cancel or rebook toolbar.
 */
- (BOOL)willShowCancelOrRebookToolbar {
    return [self willNotShowApproveDeclineToolbar];
}

- (BOOL)willShowCancelButton {
    return [self willShowCancelOrRebookToolbar] &&
    ![self willShowRebookButton];
}

- (BOOL)willShowRebookButton {
    return self.roomBooking.expired ||
    [self.roomBooking.status isEqualToString:@"canceled"] ||
    [self.roomBooking.status containsString:@"declined"];
}

/**
 *  Add cancel or rebook toolbar.
 */
-(void)addCancelOrRebookToolbar {
    if (![self willShowCancelOrRebookToolbar]) {
        return ;
    }
    
    UIView *cancelOrRebookToolbarView = [UIHelper toolbarView];
    cancelOrRebookToolbarView.top = [GlobalConstants sharedInstance].screenHeight;
    [self.navigationController.view addSubview:cancelOrRebookToolbarView];
    
    // Cancel button.
    GlobalConstants *consts = [GlobalConstants sharedInstance];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.width = consts.screenWidth;
    cancelButton.height = consts.tabBarHeight;
    cancelButton.enabled = NO;
    cancelButton.titleLabel.font = [UIFont buttonFont];
    [cancelButton setTitle:@"取消申请" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor alertColor] forState:UIControlStateNormal];
    //declineButton.backgroundColor = [UIColor alertColor];
    [cancelButton addTarget:self
                      action:@selector(cancelBooking)
            forControlEvents:UIControlEventTouchUpInside];
    [cancelOrRebookToolbarView addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    // Rebook button.
    UIButton *rebookButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rebookButton.width = consts.screenWidth;
    rebookButton.height = consts.tabBarHeight;
    rebookButton.enabled = NO;
    rebookButton.titleLabel.font = [UIFont buttonFont];
    [rebookButton setTitle:@"提交新申请" forState:UIControlStateNormal];
    [rebookButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    //approveButton.backgroundColor = [UIColor themeColor];
    [rebookButton addTarget:self
                      action:@selector(rebook)
            forControlEvents:UIControlEventTouchUpInside];
    [cancelOrRebookToolbarView addSubview:rebookButton];
    self.rebookButton = rebookButton;
    
    self.cancelOrRebookToolbarView = cancelOrRebookToolbarView;
    [self disableCancelOrRebookToolbar];
}

- (void)showCancelOrRebookToolbar {
    if (![self willShowCancelOrRebookToolbar]) {
        return ;
    }
    if ([self willShowRebookButton]) {
        self.cancelButton.hidden = YES;
    } else {
        self.rebookButton.hidden = YES;
    }
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.cancelOrRebookToolbarView.top =
                         [GlobalConstants sharedInstance].screenHeight - self.cancelOrRebookToolbarView.height;
                     }];
}

- (void)hideCancelOrRebookToolbar {
    if (![self willShowCancelOrRebookToolbar]) {
        return ;
    }
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.cancelOrRebookToolbarView.top =
                         [GlobalConstants sharedInstance].screenHeight;
                     }];
}

- (void)enableCancelOrRebookToolbar {
    if (![self willShowCancelOrRebookToolbar]) {
        return ;
    }
    
    if ([self willShowCancelButton]) {
        self.cancelButton.enabled = YES;
    } else if ([self willShowRebookButton]) {
        self.rebookButton.enabled = YES;
    }
}

- (void)disableCancelOrRebookToolbar {
    if (![self willShowCancelOrRebookToolbar]) {
        return ;
    }
    
    if ([self willShowCancelButton]) {
        self.cancelButton.enabled = NO;
    } else if ([self willShowRebookButton]) {
        self.rebookButton.enabled = NO;
    }
}

#pragma mark - Button action

- (void)showCredential {
    CredentialViewController *vc = [CredentialViewController new];
    vc.roomBooking = self.roomBooking;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  Approve this booking.
 */
- (void)approve {
    MBProgressHUD *hud = [UIHelper
                          showProcessingHUDWithMessage:@"正在同意申请..."
                          addedToView:self.view];
    
    // Send approve request.
    UserManager *userManager = [UserManager sharedInstance];
    [[APIManager sharedInstance]
     approveRoomBookingWithPersonType:userManager.userTypeStr
     personId:userManager.userId
     GroupId:self.roomBooking.groupId
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             NSString *message = jsonData[@"message"];
             if ([message isEqualToString:@"Approved."]) {
                 [UIHelper showTopSuccessView:@"同意成功！"
                           fromViewController:self.navigationController];
                 [self.navigationController popViewControllerAnimated:YES];
             } else {
                 [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
             }
         } else {
             [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
         }
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
}

/**
 *  Decline this booking.
 */
- (void)decline {
    [self disableApproveDeclineToolbar];
    DeclineViewController *vc = [DeclineViewController new];
    vc.roomBooking = self.roomBooking;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  Cancel this booking.
 */
- (void)cancelBooking {
    [self disableCancelOrRebookToolbar];
    PopupView *logoutPopup = [UIHelper popupViewWithMessage:@"是否确认取消申请？"];
    logoutPopup.confirmButtonPressedBlock = ^(void) {
        MBProgressHUD *hud = [UIHelper
                              showProcessingHUDWithMessage:@"正在取消申请..."
                              addedToView:self.view];
        
        [[APIManager sharedInstance]
         cancelBookingWithGroupId:self.roomBooking.groupId
         success:^(id jsonData) {
             if ([jsonData isKindOfClass:NSDictionary.class]) {
                 NSString *message = jsonData[@"message"];
                 if ([message isEqualToString:@"Successfully canceled booking."]) {
                     [UIHelper showTopSuccessView:@"取消申请成功！"
                               fromViewController:self.navigationController];
                     [self.navigationController popViewControllerAnimated:YES];
                 } else {
                     [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
                 }
             } else {
                 [UIHelper showServerErrorAlertViewWithViewController:self.navigationController];
             }
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

/**
 *  Rebook.
 */
- (void)rebook {
    [self disableCancelOrRebookToolbar];
    RoomBookingViewController *vc = [RoomBookingViewController new];
    vc.room = self.roomBooking.room;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
