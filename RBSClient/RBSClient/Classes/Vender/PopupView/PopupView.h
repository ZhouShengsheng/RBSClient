//
//  ForgotPassViewController.h
//  YYBao
//
//  Created by Hu Weizheng on 27/5/15.
//  Copyright (c) 2015 CAP_NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *msg_title;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (assign, nonatomic) BOOL isDisplayng;

@property (nonatomic, copy) void (^confirmButtonPressedBlock)(void);
@property (nonatomic, copy) void (^cancelButtonPressedBlock)(void);

- (void)dismiss;

@end
