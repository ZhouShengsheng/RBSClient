//
//  UIHelper.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

+ (void)showTopInfoView:(NSString*)msg fromViewController:(UIViewController*)viewController {
    // hide any pop view
    [MozTopAlertView hideViewWithParentView:viewController.view];
    // show notification
    [MozTopAlertView showWithType:MozAlertTypeInfo text:msg viewController:viewController.view];
}

+ (void)showTopSuccessView:(NSString*)msg fromViewController:(UIViewController*)viewController {
    // hide any pop view
    [MozTopAlertView hideViewWithParentView:viewController.view];
    // show notification
    [MozTopAlertView showWithType:MozAlertTypeSuccess text:msg viewController:viewController.view];
}

+ (void)showTopAlertView:(NSString*)msg fromViewController:(UIViewController*)viewController {
    // hide any pop view
    [MozTopAlertView hideViewWithParentView:viewController.view];
    // warning message
    [MozTopAlertView showWithType:MozAlertTypeWarning text:msg viewController:viewController.view];
}

+ (void)showTopErrorView:(NSString*)msg fromViewController:(UIViewController*)viewController {
    // hide any pop view
    [MozTopAlertView hideViewWithParentView:viewController.view];
    // error message
    [MozTopAlertView showWithType:MozAlertTypeError text:msg viewController:viewController.view];
}

+ (MJRefreshNormalHeader *)refreshHeaderWithTarget:(id)target action:(SEL)action {
    return [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

+ (MJRefreshAutoNormalFooter *)refreshFooterWithTarget:(id)target action:(SEL)action {
    return [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

+ (void)customizeCheckBox:(BEMCheckBox *)checkBox {
    checkBox.animationDuration = 0.3f;
    checkBox.onTintColor = [UIColor themeColor];
    checkBox.onCheckColor = [UIColor themeColor];
    checkBox.onAnimationType = BEMAnimationTypeFlat;
    checkBox.offAnimationType = BEMAnimationTypeFlat;
}

+ (PopupView *)popupViewWithMessage:(NSString*)message {
    PopupView *popupView = [PopupView new];
    KGModal *kgModal = [KGModal sharedInstance];
    kgModal.closeButtonType = KGModalCloseButtonTypeNone;
    kgModal.modalBackgroundColor = [UIColor whiteColor];
    [kgModal showWithContentViewController:popupView andAnimated:YES];
    
    popupView.msg_title.text = message;
    [popupView.confirm setTitle:@"确认" forState:UIControlStateNormal];
    [popupView.cancel setTitle:@"取消" forState:UIControlStateNormal];
    return popupView;
}

@end
