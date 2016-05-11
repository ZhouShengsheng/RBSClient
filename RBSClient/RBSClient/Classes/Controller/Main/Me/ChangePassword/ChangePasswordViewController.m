//
//  ChangePasswordViewController.m
//  RBSClient
//
//  Created by Shengsheng on 11/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserProfileCell.h"
#import "UserManager.h"
#import "APIManager.h"

@interface ChangePasswordViewController ()

// Cells.
@property(strong, nonatomic) UserProfileCell *currentPasswordCell;
@property(strong, nonatomic) UserProfileCell *passwordCell;
@property(strong, nonatomic) UserProfileCell *passwordConfirmCell;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    // Title.
    self.title = @"修改密码";
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"UserProfileCell" bundle:nil]
         forCellReuseIdentifier:@"UserProfileCell"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [UIView new];
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    // Bar button.
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"修改"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(changePassword)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserProfileCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UserProfileCell"
                             forIndexPath:indexPath];
    [cell setEditEnable:YES];
    [cell setSecureInput:YES];
    
    switch (indexPath.row) {
        case 0: {
            [cell displayKey:@"当前密码" value:@""];
            self.currentPasswordCell = cell;
            break;
        }
        case 1: {
            [cell displayKey:@"新密码" value:@""];
            self.passwordCell= cell;
            break;
        }
        case 2: {
            [cell displayKey:@"新密码确认" value:@""];
            self.passwordConfirmCell = cell;
            break;
        }
    }
    
    return cell;
}

#pragma mark - Change password action
- (void)changePassword {
    UserManager *userManager = [UserManager sharedInstance];
    NSString *currentPassword = self.currentPasswordCell.value;
    
    // Check current password.
    if (![currentPassword isEqualToString:userManager.password]) {
        [UIHelper showTopErrorView:@"当前密码不正确！"
                fromViewController:self.navigationController];
        return ;
    }
    
    // Check new password input.
    NSString *newPassword = self.passwordCell.value;
    if (newPassword == nil ||
        [newPassword isEqualToString:@""]) {
        [UIHelper showTopAlertView:@"请输入新密码！"
                fromViewController:self.navigationController];
    }
    
    // Check password confirmation.
    NSString *newPasswordConfirm = self.passwordConfirmCell.value;
    if (![newPassword isEqualToString:newPasswordConfirm]) {
        [UIHelper showTopAlertView:@"密码确认不一致！"
                fromViewController:self.navigationController];
        return ;
    }
    
    // Configure hud.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在修改密码...";
    
    // Change password.
    [[APIManager sharedInstance]
     changePasswordWithType:userManager.userTypeStr
     userId:userManager.userId
     password:currentPassword
     newPassword:newPassword
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             NSString *message = jsonData[@"message"];
             if ([message isEqualToString:@"Password changed."]) {
                 [UIHelper showTopSuccessView:@"修改密码成功！"
                           fromViewController:self.navigationController];
                 [self.navigationController popViewControllerAnimated:YES];
                 userManager.password = newPassword;
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
         [hud hide:YES];
         [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                 fromViewController:self.navigationController];
     }];
}

@end
