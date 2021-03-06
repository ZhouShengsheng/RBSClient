//
//  LoginViewController.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
#import "APIManager.h"
#import "UIHelper.h"
#import "MainController.h"
#import "UserManager.h"
#import "PushNotificationManager.h"

@interface LoginViewController () <UITextFieldDelegate, BEMCheckBoxDelegate>

@property (strong, nonatomic) UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UIView *loginViewGroup;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;
@property (weak, nonatomic) IBOutlet BEMCheckBox *adminCheckBox;
@property (weak, nonatomic) IBOutlet BEMCheckBox *facultyCheckBox;
@property (weak, nonatomic) IBOutlet BEMCheckBox *studentCheckBox;

@property (assign, nonatomic) BOOL loginGroupShowed;

@end

@implementation LoginViewController

#pragma mark - Init

- (void)viewDidLoad {
    [self initView];
    [self autoLogin];
}

- (void)dealloc {
    [self.appImageView removeFromSuperview];
    self.appImageView = nil;
}

/**
 *  Init views.
 */
- (void)initView {
    GlobalConstants *constants = [GlobalConstants sharedInstance];
    UIImage *appImage = [UIImage imageNamed:@"launchScreenTopImage"];
    self.appImageView = [[UIImageView alloc]
                         initWithFrame:CGRectMake((constants.screenWidth - appImage.size.width)/2,
                                                  (constants.screenHeight - appImage.size.height)/2 - 100,
                                                  appImage.size.width, appImage.size.height)];
    self.appImageView.image = appImage;
    self.appImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.appImageView];
    
    // set login button corner radius
    self.loginButton.layer.cornerRadius = 5;
    
    // hide login indicator
    self.loginIndicator.hidesWhenStopped = YES;
    
    // set textfield delegate
    self.idTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    // Check box.
    [UIHelper customizeCheckBox:self.adminCheckBox];
    [UIHelper customizeCheckBox:self.facultyCheckBox];
    [UIHelper customizeCheckBox:self.studentCheckBox];
    self.adminCheckBox.delegate = self;
    self.facultyCheckBox.delegate = self;
    self.studentCheckBox.delegate = self;
}

#pragma mark - Login
//=========================================================================================
// Login
//=========================================================================================
/**
 *  try to auto login.
 */
- (void)autoLogin {
    self.loginViewGroup.alpha = 0;
    [[UserManager sharedInstance]
     autoLoginWithCompletion:^(BOOL succeed, NSString *message) {
         if (succeed) {
             [self loginSucceedWithData:nil];
         } else {
             [self showLoginGroup];
             if ([message isEqualToString:@"初始用户。"]) {
                 [self.adminCheckBox setOn:YES animated:NO];
             } else {
                 [self loginFailWithMessage:message];
                 switch ([UserManager sharedInstance].userType) {
                     case USER_TYPE_UNKNOWN: {
                         [self.adminCheckBox setOn:YES animated:NO];
                         break;
                     }
                     case USER_TYPE_ADMIN: {
                         [self.adminCheckBox setOn:YES animated:NO];
                         break;
                     }
                     case USER_TYPE_FACULTY: {
                         [self.facultyCheckBox setOn:YES animated:NO];
                         break;
                     }
                     case USER_TYPE_STUDENT: {
                         [self.studentCheckBox setOn:YES animated:NO];
                         break;
                     }
                 }
             }
         }
     }];
}

/**
 *  Show login group.
 */
- (void)showLoginGroup {
    if (self.loginGroupShowed) {
        return ;
    }
    self.loginGroupShowed = YES;
    [UIView animateWithDuration:0.8f
                          delay:0.25f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.appImageView.frame;
                         frame.origin.y -= 50;
                         self.appImageView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self setUpLogin];
                         [UIView animateWithDuration:0.25
                                          animations:^{
                                              self.loginViewGroup.alpha = 1;
                                          }
                          completion:^(BOOL finished) {
                              [self.idTextField becomeFirstResponder];
                          }];
                     }];
}

- (void)logout {
    [self.adminCheckBox setOn:YES animated:NO];
    [self checkCheckBox:self.adminCheckBox];
    self.idTextField.text = nil;
    self.passwordTextField.text = nil;
    [self showLoginGroup];
    [self setUpLogin];
}

/**
 *  Set up views for login.
 */
- (void)setUpLogin {
    [self.loginIndicator stopAnimating];
    [self checkLoginButton];
    self.idTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    [self.loginButton addTarget:self
                         action:@selector(loginAction)
               forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  Start login.
 */
- (void)loginAction {
    [self.view endEditing:YES];
    if (!self.loginButton.enabled) {
        return ;
    }
    
    // Type.
    NSString *type;
    if (self.facultyCheckBox.on) {
        type = @"faculty";
    } else if (self.studentCheckBox.on) {
        type = @"student";
    } else if (self.adminCheckBox.on) {
        type = @"admin";
    } else {
        [UIHelper showTopAlertView:@"请选择身份类型！"
                fromViewController:self];
        return ;
    }
    
    [self.loginIndicator startAnimating];
    self.loginButton.enabled = NO;
    self.idTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    
    [[APIManager sharedInstance]
     loginWithType:type
     userId:self.idTextField.text
     password:self.passwordTextField.text
     success:^(id jsonData) {
         NSString *message = jsonData[@"message"];
         if (!message) {
             [self loginSucceedWithData:jsonData];
         } else {
             DDLogError(@"Login message: %@", message);
             [self loginFailWithMessage:@"登录失败！学工号或密码错误！"];
         }
     }
     failure:^(NSError *error) {
        [self loginFailWithMessage:@"登录失败...请稍后重试。"];
     }
     timeout:^{
         [self loginFailWithMessage:@"登陆超时...请稍后重试。"];
     }];
}

/**
 *  Login succeed callback.
 */
- (void)loginSucceedWithData:(id) jsonData {
    DDLogError(@"loginSucceed");
    
    if (jsonData) {
        // Save user logged in.
        UserManager *userManager = [UserManager sharedInstance];
        if (self.facultyCheckBox.on) {
            Faculty *faculty = [[Faculty alloc] initWithJsonData:jsonData];
            faculty.password = self.passwordTextField.text;
            userManager.faculty = faculty;
            userManager.userType = USER_TYPE_FACULTY;
        } else if (self.studentCheckBox.on) {
            Student *student = [[Student alloc] initWithJsonData:jsonData];
            student.password = self.passwordTextField.text;
            
            Faculty *faculty = [[Faculty alloc] initWithJsonData:jsonData[@"supervisor"]];
            student.supervisor = faculty;
            
            userManager.student = student;
            userManager.userType = USER_TYPE_STUDENT;
        } else {
            Faculty *admin = [[Faculty alloc] initWithJsonData:jsonData];
            admin.password = self.passwordTextField.text;
            userManager.admin = admin;
            userManager.userType = USER_TYPE_ADMIN;
        }
        
        [userManager saveUserData];
        
        // Update apn token.
        [[PushNotificationManager sharedInstance]
         uploadAPNToken];
    }
    
    MainController *mainController = [MainController sharedInstance];
    mainController.loginController = self;
    [mainController setupRootViewController];
}

/**
 *  Login fail callback.
 */
- (void)loginFailWithMessage:(NSString *)message {
    DDLogError(@"loginFail");
    
    [self setUpLogin];
    [UIHelper showTopAlertView:message fromViewController:self];
}

#pragma mark - TextField delegate methods
//=========================================================================================
// TextField delegate methods
//=========================================================================================
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        if (textField == self.passwordTextField) {
            [self loginAction];
        }
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkLoginButton];
    });
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkLoginButton];
    });
    return YES;
}

- (void)checkLoginButton {
    self.loginButton.enabled = (self.idTextField.text.length > 0 &&
                                self.passwordTextField.text.length > 0);
}

#pragma mark - BEMCheckBox delegate

/**
 *  Keep single choice on login type.
 */
- (void)checkCheckBox:(BEMCheckBox *)checkBox {
    if (checkBox.on) {
        if (checkBox == self.facultyCheckBox) {
            [self.adminCheckBox setOn:NO animated:YES];
            [self.studentCheckBox setOn:NO animated:YES];
        } else if (checkBox == self.adminCheckBox) {
            [self.studentCheckBox setOn:NO animated:YES];
            [self.facultyCheckBox setOn:NO animated:YES];
        } else {
            [self.facultyCheckBox setOn:NO animated:YES];
            [self.adminCheckBox setOn:NO animated:YES];
        }
    }
}

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    if (checkBox.on) {
        if (checkBox == self.facultyCheckBox) {
            [self.adminCheckBox setOn:NO animated:YES];
            [self.studentCheckBox setOn:NO animated:YES];
        } else if (checkBox == self.adminCheckBox) {
            [self.studentCheckBox setOn:NO animated:YES];
            [self.facultyCheckBox setOn:NO animated:YES];
        } else {
            [self.facultyCheckBox setOn:NO animated:YES];
            [self.adminCheckBox setOn:NO animated:YES];
        }
    }
}

@end
