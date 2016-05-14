//
//  UIHelper.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

#pragma mark - Top prompt view

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

/**
 *  Show server error alert view.
 */
+ (void)showServerErrorAlertViewWithViewController:(UIViewController *)viewController {
    [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
            fromViewController:viewController];
}

/**
 *  Show server error alert view.
 */
+ (void)showTimeoutAlertViewWithViewController:(UIViewController *)viewController {
    [UIHelper showTopAlertView:@"请求超时！请稍后重试！"
            fromViewController:viewController];
}

#pragma mark - HUD

+ (MBProgressHUD *)showProcessingHUDWithMessage:(NSString *)message addedToView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
    return hud;
}

#pragma mark - Refresh header and footer

+ (MJRefreshNormalHeader *)refreshHeaderWithTarget:(id)target action:(SEL)action {
    return [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

+ (MJRefreshAutoNormalFooter *)refreshFooterWithTarget:(id)target action:(SEL)action {
    return [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

#pragma mark - Check box

+ (void)customizeCheckBox:(BEMCheckBox *)checkBox {
    checkBox.animationDuration = 0.3f;
    checkBox.onTintColor = [UIColor themeColor];
    checkBox.onCheckColor = [UIColor themeColor];
    checkBox.onAnimationType = BEMAnimationTypeFlat;
    checkBox.offAnimationType = BEMAnimationTypeFlat;
}

#pragma mark - Popup view

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

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message inViewController:(UIViewController *)controller {
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Called when user taps outside
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [controller presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Toolbar

+ (UIToolbar *)generalToolbar {
    GlobalConstants *consts = [GlobalConstants sharedInstance];
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, consts.screenHeight - consts.tabBarHeight,
                                     consts.screenWidth, consts.tabBarHeight)];
    [toolbar setBarStyle:UIBarStyleDefault];
    toolbar.layer.shadowColor = [UIColor grayColor].CGColor;
    toolbar.layer.shadowOffset = CGSizeMake(0, -2);
    return toolbar;
}

+ (UIView *)toolbarView {
    GlobalConstants *consts = [GlobalConstants sharedInstance];
    UIView *toolbarView = [[UIView alloc]
                           initWithFrame:CGRectMake(0, consts.screenHeight - consts.tabBarHeight,
                                                    consts.screenWidth, consts.tabBarHeight)];
    toolbarView.backgroundColor = [UIColor whiteColor];
    toolbarView.layer.shadowColor = [UIColor blackColor].CGColor;
    toolbarView.layer.shadowOffset = CGSizeMake(0, -2.0);
    toolbarView.layer.shadowOpacity = 0.25;
    toolbarView.layer.masksToBounds = NO;
    //toolbarView.layer.shouldRasterize = YES;
    return toolbarView;
}

#pragma mark - Paged scroll view

+ (UIScrollView *)initializeViewFrameForViewControllers:(UIViewController*)viewController viewControllers:(NSArray*)controllers checkPopGesture:(BOOL)checkPopGesture {
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:
                                       CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
    [contentScrollView setPagingEnabled:YES];
    contentScrollView.bounces = YES;
    contentScrollView.backgroundColor = [UIColor clearColor];
    [contentScrollView setShowsHorizontalScrollIndicator:NO];
    contentScrollView.scrollsToTop = NO;
    
    for (int i=0; i < [controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [controllers objectAtIndex:i];
        
        [[controller view] setFrame:CGRectMake(i * contentScrollView.frame.size.width,
                                               0.0,
                                               contentScrollView.frame.size.width,
                                               contentScrollView.frame.size.height)];
        [contentScrollView addSubview:[controller view]];
    }
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [contentScrollView setContentSize:CGSizeMake(viewController.view.frame.size.width * [controllers count], viewController.view.frame.size.height)];
    [viewController.view addSubview:contentScrollView];
    
    if (checkPopGesture) {
        for (UIGestureRecognizer *gestureRecognizer in contentScrollView.gestureRecognizers) {
            if (viewController.navigationController)
                [gestureRecognizer requireGestureRecognizerToFail:viewController.navigationController.interactivePopGestureRecognizer];
        }
    }
    return contentScrollView;
}

#pragma mark - Segmented controller

+ (HMSegmentedControl *)segmentedControllerForBookingList {
    HMSegmentedControl *segmentController = [HMSegmentedControl new];
    segmentController.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentController.backgroundColor = [UIColor clearColor];
    
    segmentController.selectionIndicatorHeight = 3.0f;
    segmentController.selectedTitleTextAttributes =
    @{NSForegroundColorAttributeName: [UIColor themeColor]};
    segmentController.selectionIndicatorColor = [UIColor themeColor];
    
    segmentController.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentController.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentController.verticalDividerEnabled = NO;
    segmentController.verticalDividerColor = [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1];
    
    //segmentController.segmentEdgeInset = UIEdgeInsetsMake(0, 13, 0, 13);
    segmentController.opaque = NO;
    segmentController.shouldAnimateUserSelection = YES;
    
    segmentController.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],
                                              NSFontAttributeName:[UIFont systemFontOfSize:16]};
    
    segmentController.borderType = HMSegmentedControlBorderTypeNone;
    return segmentController;
}

#pragma mark - Table view footer view

+ (void)configureTableFooterView:(UITableView *)tableView {
    tableView.tableFooterView =
    [[UIView alloc]
     initWithFrame:CGRectMake(0, 0, 0,
                              [GlobalConstants sharedInstance].tabBarHeight)];
}

@end
