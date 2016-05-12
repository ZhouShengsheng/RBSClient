//
//  UserProfileViewController.m
//  RBSClient
//
//  Created by Shengsheng on 11/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserProfileCell.h"
#import "UserManager.h"
#import "APIManager.h"

@interface UserProfileViewController ()

@property(assign, nonatomic) BOOL isSupervisor;
@property(strong, nonatomic) UIBarButtonItem *barButton;

// Cells.
@property(strong, nonatomic) UserProfileCell *designationOrClassCell;
@property(strong, nonatomic) UserProfileCell *officeOrDormCell;
@property(strong, nonatomic) UserProfileCell *phoneCell;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    // Title.
    if (self.faculty) {
        self.title = @"上级信息";
    } else {
        self.title = @"个人信息";
    }
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"UserProfileCell" bundle:nil]
         forCellReuseIdentifier:@"UserProfileCell"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [UIView new];
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    // Bar button.
    NSString *title;
    if (self.faculty) {
        // 添加/删除
        title = @"--";
        [self checkSupervisor];
    } else {
        title = @"保存";
    }
    self.barButton = [[UIBarButtonItem alloc]
                      initWithTitle:title
                      style:UIBarButtonItemStylePlain
                      target:self
                      action:@selector(barButtonAction)];
    self.navigationItem.rightBarButtonItem = self.barButton;
    
    [self.tableView reloadData];
}

- (void)checkSupervisor {
    [[APIManager sharedInstance]
     checkIsSupervisorWithStudentId:[UserManager sharedInstance].userId
     facultyId:self.faculty.facultyId
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             NSString *message = jsonData[@"message"];
             if ([message isEqualToString:@"Yes."]) {
                 self.isSupervisor = YES;
             } else {
                 self.isSupervisor = NO;
             }
             [self updateBarButton];
         }
     }
     failure:^(NSError *error) {
         
     }
     timeout:^{
         
     }];
}

- (void)updateBarButton {
    if (self.isSupervisor) {
        self.barButton.title = @"移除";
    } else {
        self.barButton.title = @"添加";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserProfileCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UserProfileCell"
                             forIndexPath:indexPath];
    
    UserManager *userManager = [UserManager sharedInstance];
    
    switch (indexPath.row) {
        case 0: {
            if (self.faculty) {
                [cell displayKey:@"姓名" value:self.faculty.name];
            } else {
                [cell displayKey:@"姓名" value:userManager.userName];
            }
            [cell setEditEnable:NO];
            break;
        }
        case 1: {
            if (self.faculty) {
                [cell displayKey:@"学工号" value:self.faculty.facultyId];
            } else {
                [cell displayKey:@"学工号" value:userManager.userId];
            }
            [cell setEditEnable:NO];
            break;
        }
        case 2: {
            if (self.faculty) {
                [cell displayKey:@"性别" value:self.faculty.genderStr];
            } else {
                [cell displayKey:@"性别" value:userManager.genderStr];
            }
            [cell setEditEnable:NO];
            break;
        }
        case 3: {
            if (self.faculty) {
                [cell displayKey:@"职称" value:self.faculty.designation];
            } else {
                NSArray *designationOrClass = userManager.designationOrClass;
                [cell displayKey:designationOrClass[0] value:designationOrClass[1]];
            }
            [cell setEditEnable:NO];
            self.designationOrClassCell = cell;
            break;
        }
        case 4: {
            if (self.faculty) {
                [cell displayKey:@"办公室" value:self.faculty.office];
                [cell setEditEnable:NO];
            } else {
                NSArray *officeOrDorm = userManager.officeOrDorm;
                [cell displayKey:officeOrDorm[0] value:officeOrDorm[1]];
            }
            self.officeOrDormCell = cell;
            break;
        }
        case 5: {
            if (self.faculty) {
                [cell displayKey:@"电话号码" value:self.faculty.phone];
                [cell setEditEnable:NO];
            } else {
                [cell displayKey:@"电话号码" value:userManager.phone];
            }
            self.phoneCell = cell;
            break;
        }
    }
    
    return cell;
}

#pragma mark - Save button action

- (void)barButtonAction {
    if (self.faculty) {
        if (self.isSupervisor) {
            [self removeSupervisor];
        } else {
            [self addSupervisor];
        }
    } else {
        [self updateUserProfile];
    }
}

/**
 *  Add supervisor.
 */
- (void)addSupervisor {
    // Configure hud.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在添加上级...";
    
    [[APIManager sharedInstance]
     addSupervisorWithStudentId:[UserManager sharedInstance].userId
     facultyId:self.faculty.facultyId
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             NSString *message = jsonData[@"message"];
             if ([message isEqualToString:@"Successfully added supervisor."]) {
                 [UIHelper showTopSuccessView:@"添加上级成功！"
                           fromViewController:self.navigationController];
                 self.isSupervisor = YES;
                 [self updateBarButton];
             } else {
                 [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                         fromViewController:self.navigationController];
             }
         } else {
             [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                     fromViewController:self.navigationController];
         }
         [hud hide:YES];
     }
     failure:^(NSError *error) {
         [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }
     timeout:^{
         [UIHelper showTopAlertView:@"等待超时！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }];
}

/**
 *  Remove supervisor.
 */
- (void)removeSupervisor {
    // Configure hud.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在移除上级...";
    
    [[APIManager sharedInstance]
     removeSupervisorWithStudentId:[UserManager sharedInstance].userId
     facultyId:self.faculty.facultyId
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             NSString *message = jsonData[@"message"];
             if ([message isEqualToString:@"Successfully deleted supervisor."]) {
                 [UIHelper showTopSuccessView:@"移除上级成功！"
                           fromViewController:self.navigationController];
                 self.isSupervisor = NO;
                 [self updateBarButton];
             } else if([message isEqualToString:@"Class supervisor cannot be deleted."]) {
                 [UIHelper showTopAlertView:@"辅导员不可移除！"
                         fromViewController:self.navigationController];
             } else {
                 [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                         fromViewController:self.navigationController];
             }
         } else {
             [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                     fromViewController:self.navigationController];
         }
         [hud hide:YES];
     }
     failure:^(NSError *error) {
         [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }
     timeout:^{
         [UIHelper showTopAlertView:@"等待超时！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }];
}

/**
 *  Update user profile.
 */
- (void)updateUserProfile {
    UserManager *userManager = [UserManager sharedInstance];
    
    // Parameters.
    NSString *designation = nil;
    NSString *office = nil;
    NSString *dormRoomNumber = nil;
    NSString *phone = self.phoneCell.value;
    
    switch (userManager.userType) {
        case USER_TYPE_UNKNOWN: {
            return ;
        }
        case USER_TYPE_ADMIN: {
        }
        case USER_TYPE_FACULTY: {
            designation = self.designationOrClassCell.value;
            office = self.officeOrDormCell.value;
            break;
        }
        case USER_TYPE_STUDENT: {
            dormRoomNumber = self.officeOrDormCell.value;
            break;
        }
    }
    
    // Configure hud.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存个人信息...";
    
    [[APIManager sharedInstance]
     updateUserInfoWithType:userManager.userTypeStr
     userId:userManager.userId
     designation:designation
     office:office
     dormRoomNumber:dormRoomNumber
     phone:phone
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             NSString *message = jsonData[@"message"];
             if ([message isEqualToString:@"User updated."]) {
                 [UIHelper showTopSuccessView:@"个人信息保存成功！"
                           fromViewController:self.navigationController];
                 [self.navigationController popViewControllerAnimated:YES];
                 
                 switch (userManager.userType) {
                     case USER_TYPE_UNKNOWN: {
                         return ;
                     }
                     case USER_TYPE_ADMIN: {
                         Faculty *admin = userManager.admin;
                         admin.designation = designation;
                         admin.office = office;
                         break;
                     }
                     case USER_TYPE_FACULTY: {
                         Faculty *faculty = userManager.faculty;
                         faculty.designation = designation;
                         faculty.office = office;
                         break;
                     }
                     case USER_TYPE_STUDENT: {
                         Student *student = userManager.student;
                         student.dormRoomNumber = dormRoomNumber;
                         student.phone = phone;
                         break;
                     }
                 }
             } else {
                 [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                         fromViewController:self.navigationController];
             }
         } else {
             [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                     fromViewController:self.navigationController];
         }
         [hud hide:YES];
     }
     failure:^(NSError *error) {
         [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }
     timeout:^{
         [UIHelper showTopAlertView:@"等待超时！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }];
}

@end
