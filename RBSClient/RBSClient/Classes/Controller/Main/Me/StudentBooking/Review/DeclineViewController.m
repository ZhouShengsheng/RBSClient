//
//  DeclineViewController.m
//  RBSClient
//
//  Created by Shengsheng on 13/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "DeclineViewController.h"
#import "UIHelper.h"
#import "APIManager.h"
#import "UserManager.h"

@interface DeclineViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *declineReasonTextView;

@end

@implementation DeclineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
}

- (void)initializeView {
    //To make the border look very close to a UITextField
    [self.declineReasonTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.declineReasonTextView.layer setBorderWidth:2.0];
    self.declineReasonTextView.delegate = self;
    
    //The rounded corner part, where you specify your view's corner radius:
    self.declineReasonTextView.layer.cornerRadius = 5;
    self.declineReasonTextView.clipsToBounds = YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Bar button
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"提交"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(decline)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self.declineReasonTextView becomeFirstResponder];
}


// Decline room booking.
- (void)decline {
    NSString *declineReason = self.declineReasonTextView.text;
    if (!declineReason || [declineReason isEqualToString:@""]) {
        [UIHelper showTopAlertView:@"请输入拒绝理由！"
                fromViewController:self.navigationController];
        [self.declineReasonTextView becomeFirstResponder];
        return ;
    }
    
    [self.declineReasonTextView resignFirstResponder];
    
    // Configure hud.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在拒绝申请...";
    
    // Send approve request.
    UserManager *userManager = [UserManager sharedInstance];
    [[APIManager sharedInstance]
     declineRoomBookingWithPersonType:userManager.userTypeStr
     personId:userManager.userId
     GroupId:self.roomBooking.groupId
     declineReason:declineReason
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             NSString *message = jsonData[@"message"];
             if ([message isEqualToString:@"Declined."]) {
                 [UIHelper showTopSuccessView:@"拒绝成功！"
                           fromViewController:self.navigationController];
                 if (userManager.userType == USER_TYPE_ADMIN) {
                     self.roomBooking.status = @"admin_declined";
                 } else if (userManager.userType == USER_TYPE_FACULTY) {
                     self.roomBooking.status = @"faculty_declined";
                 }
                 self.roomBooking.declineReason = declineReason;
                 [self.navigationController popViewControllerAnimated:YES];
                 //[self.navigationController popViewControllerAnimated:YES];
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
         [UIHelper showTopAlertView:@"请求超时！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }];
}

/**
 *  Hide keyboard when hit return key.
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
