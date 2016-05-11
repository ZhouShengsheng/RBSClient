//
//  UIHelper.h
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Venders.h"

@interface UIHelper : NSObject

/**
 *  Display top popup info view.
 */
+ (void)showTopInfoView:(NSString*)msg fromViewController:(UIViewController*)viewController;

/**
 *  Display top popup success view.
 */
+ (void)showTopSuccessView:(NSString*)msg fromViewController:(UIViewController*)viewController;

/**
 *  Display top popup alert view.
 */
+ (void)showTopAlertView:(NSString*)msg fromViewController:(UIViewController*)viewController;

/**
 *  Display top popup error view.
 */
+ (void)showTopErrorView:(NSString*)msg fromViewController:(UIViewController*)viewController;

/**
 *  Create a new refresh header.
 */
+ (MJRefreshNormalHeader *)refreshHeaderWithTarget:(id)target action:(SEL)action;

/**
 *  Create a new refresh footer.
 */
+ (MJRefreshAutoNormalFooter *)refreshFooterWithTarget:(id)target action:(SEL)action;

/**
 *  customize check box.
 */
+ (void)customizeCheckBox:(BEMCheckBox *)checkBox;

/**
 *  Create popup view with message.
 */
+ (PopupView *)popupViewWithMessage:(NSString*)message;

@end
