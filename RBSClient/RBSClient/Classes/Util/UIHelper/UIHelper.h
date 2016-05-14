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

#pragma mark - Top prompt view

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
 *  Show server error alert view.
 */
+ (void)showServerErrorAlertViewWithViewController:(UIViewController *)viewController;

/**
 *  Show server error alert view.
 */
+ (void)showTimeoutAlertViewWithViewController:(UIViewController *)viewController;

#pragma mark - HUD

+ (MBProgressHUD *)showProcessingHUDWithMessage:(NSString *)message addedToView:(UIView *)view;

#pragma mark - Refresh header and footer

/**
 *  Create a new refresh header.
 */
+ (MJRefreshNormalHeader *)refreshHeaderWithTarget:(id)target action:(SEL)action;

/**
 *  Create a new refresh footer.
 */
+ (MJRefreshAutoNormalFooter *)refreshFooterWithTarget:(id)target action:(SEL)action;

#pragma mark - Check box

/**
 *  customize check box.
 */
+ (void)customizeCheckBox:(BEMCheckBox *)checkBox;

#pragma mark - Popup view

/**
 *  Create popup view with message.
 */
+ (PopupView *)popupViewWithMessage:(NSString*)message;

/**
 *  Show alert view.
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message inViewController:(UIViewController *)controller;

#pragma mark - Toolbar

/**
 *  Create a general toolbar.
 */
+ (UIToolbar *)generalToolbar;

/**
 *  Create toolbar view.
 */
+ (UIView *)toolbarView;

#pragma mark - Paged scroll view

/**
 *  Create paged scroll view with view controllers.
 */
+ (UIScrollView*)initializeViewFrameForViewControllers:(UIViewController*)viewController viewControllers:(NSArray*)controllers checkPopGesture:(BOOL)checkPopGesture;

#pragma mark - Segmented controller

/**
 *  Create segmented controller for booking list.
 */
+ (HMSegmentedControl *)segmentedControllerForBookingList;

#pragma mark - Table view footer view

/**
 *  Configure table footer view.
 */
+ (void)configureTableFooterView:(UITableView *)tableView;

@end
