//
//  UIHelper.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

/**
 *  Display top popup info view.
 */
+ (void)showTopInfoView:(NSString*)msg fromViewController:(UIViewController*)viewController {
    // hide any pop view
    [MozTopAlertView hideViewWithParentView:viewController.view];
    // show notification
    [MozTopAlertView showWithType:MozAlertTypeInfo text:msg viewController:viewController.view];
}

/**
 *  Display top popup success view.
 */
+ (void)showTopSuccessView:(NSString*)msg fromViewController:(UIViewController*)viewController {
    // hide any pop view
    [MozTopAlertView hideViewWithParentView:viewController.view];
    // show notification
    [MozTopAlertView showWithType:MozAlertTypeSuccess text:msg viewController:viewController.view];
}

/**
 *  Display top popup alert view.
 */
+ (void)showTopAlertView:(NSString*)msg fromViewController:(UIViewController*)viewController {
    // hide any pop view
    [MozTopAlertView hideViewWithParentView:viewController.view];
    // warning message
    [MozTopAlertView showWithType:MozAlertTypeWarning text:msg viewController:viewController.view];
}

/**
 *  Display top popup error view.
 */
+ (void)showTopErrorView:(NSString*)msg fromViewController:(UIViewController*)viewController {
    // hide any pop view
    [MozTopAlertView hideViewWithParentView:viewController.view];
    // error message
    [MozTopAlertView showWithType:MozAlertTypeError text:msg viewController:viewController.view];
}

@end
