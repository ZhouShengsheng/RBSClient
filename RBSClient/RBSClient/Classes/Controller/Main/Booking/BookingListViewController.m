//
//  BookingListViewController.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "BookingListViewController.h"
#import "DetailedBookingListViewController.h"
#import "UserManager.h"
#import "NotificationBadgeController.h"
#import "PushNotificationManager.h"

@interface BookingListViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property(assign, nonatomic) CGFloat lastContentOffset;
@property(assign, nonatomic) long previousIndex;
@property(assign, nonatomic) long currentIndex;

@property(strong, nonatomic) HMSegmentedControl *segmentController;
@property(strong, nonatomic) UIScrollView *contentScrollView;
@property(strong, nonatomic) NSArray<id<RecyclableViewController>> *controllers;

@end

@implementation BookingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!self.controllers) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        // initialize all viewControllers
        self.controllers = [self initializeViewControllers];
        
        // initialize the view frame of all viewControllers
        if (self.controllers){
            self.contentScrollView =
            [UIHelper
             initializeViewFrameForViewControllers:self
             viewControllers:self.controllers
             checkPopGesture:NO];
            self.contentScrollView.delegate = self;
            
            // initialize titles & segment controls
            [self initSegmentedController];
            
            // display the first view
            [self displaySelectedView:0];
            
            [self addBadgeNotificationObserver];
        }
    }
    else {
        [self displaySelectedView:self.currentIndex];
    }
}

#pragma mark - Init views and view controllers

/**
 *  Init view controllers.
 */
- (NSArray *)initializeViewControllers {
    if ([UserManager sharedInstance].userType == USER_TYPE_ADMIN) {
        // Admin.
        DetailedBookingListViewController * processingViewController =
        [DetailedBookingListViewController new];
        processingViewController.bookingType = BOOKING_TYPE_ADMIN_PROCESSING;
        processingViewController.parentNavigationController = self.navigationController;
        processingViewController.title = @"待处理申请";
        DetailedBookingListViewController * proccessedViewController =
        [DetailedBookingListViewController new];
        proccessedViewController.bookingType = BOOKING_TYPE_ADMIN_PROCCESSED;
        proccessedViewController.title = @"已处理申请";
        proccessedViewController.parentNavigationController = self.navigationController;
        
        return @[processingViewController, proccessedViewController];
    } else {
        // User.
        DetailedBookingListViewController * processingViewController =
        [DetailedBookingListViewController new];
        processingViewController.bookingType = BOOKING_TYPE_PROCESSING;
        processingViewController.parentNavigationController = self.navigationController;
        processingViewController.title = @"正在申请";
        DetailedBookingListViewController * approvedViewController =
        [DetailedBookingListViewController new];
        approvedViewController.bookingType = BOOKING_TYPE_APPROVED;
        approvedViewController.title = @"申请成功";
        approvedViewController.parentNavigationController = self.navigationController;
        DetailedBookingListViewController * declinedViewController =
        [DetailedBookingListViewController new];
        declinedViewController.bookingType = BOOKING_TYPE_DECLINED;
        declinedViewController.title = @"申请失败";
        declinedViewController.parentNavigationController = self.navigationController;
        
        return @[processingViewController, approvedViewController, declinedViewController];
    }
    
}

- (void)initSegmentedController {
    self.segmentController = [UIHelper segmentedControllerForBookingList];
    self.segmentController.frame = CGRectZero;
    self.segmentController.shouldReportEveryTouch = YES;
    [self.segmentController addTarget:self action:@selector(segmentedControllerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSArray *titleItems;
    if ([UserManager sharedInstance].userType == USER_TYPE_ADMIN) {
        // Admin.
        titleItems = @[@"待处理申请",
                       @"已处理申请"];
    } else {
        // User.
        titleItems = @[@"正在申请",
                       @"申请成功",
                       @"申请失败"];
    }
    [self.segmentController setSectionTitles:titleItems];
    GlobalConstants *consts = [GlobalConstants sharedInstance];
    self.segmentController.frame = CGRectMake(0, 0, consts.screenWidth,
                                         consts.navigationBarHeight);
    
    self.navigationItem.titleView = self.segmentController;
}

#pragma mark - Display or release sub view controllers

/**
 *  Display selected page view.
 */
- (void)displaySelectedView:(long)pageIndex {
    //    if (self.badgeController && pageIndex == 1) {
    //        [self removeBadgeWithWillDecreaseValue:YES];
    //    }
    
    [self updateScrollToTop:pageIndex];
    self.currentIndex = pageIndex;
    id<RecyclableViewController> currentController = [self.controllers objectAtIndex:pageIndex];
    self.title = ((UIViewController *)currentController).title;
    
    // init view
    [currentController initializeView];
    
    if (self.previousIndex != self.currentIndex) {
        self.previousIndex = self.currentIndex;
    }
}

/**
 *  Scroll to top.
 */
- (void)updateScrollToTop:(long)pageIndex {
    // set scrollViews scrollToTop
    for (int i = 0; i < self.controllers.count; i++) {
        id<RecyclableViewController> currentController = [self.controllers objectAtIndex:i];
        if (i == pageIndex) {
            if ([currentController conformsToProtocol:@protocol(RecyclableViewController)]) {
                [currentController currentScrollView].scrollsToTop = YES;
            }
        }
        else {
            if ([currentController conformsToProtocol:@protocol(RecyclableViewController)]) {
                [currentController currentScrollView].scrollsToTop = NO;
            }
        }
    }
}

#pragma mark - Segmented controller delegate method

- (void)segmentedControllerValueChanged:(HMSegmentedControl *)segmentedControl {
    // if has badge value, refresh user message
    SSBadgeController *badageController =
    segmentedControl.badgeControllers[segmentedControl.selectedSegmentIndex];
    if (badageController.badgeValue &&
        segmentedControl.selectedSegmentIndex == self.currentIndex) {
        [self.controllers[self.currentIndex] reloadData];
    } else if (segmentedControl.selectedSegmentIndex == self.currentIndex) {
        return ;
    }
    CGRect rect = CGRectMake(self.view.frame.size.width * segmentedControl.selectedSegmentIndex,
                             0.0,
                             self.view.frame.size.width,
                             self.contentScrollView.contentSize.height);
    [self.contentScrollView scrollRectToVisible:rect animated:NO];
    [self displaySelectedView:self.segmentController.selectedSegmentIndex];
}

#pragma mark - Scrollview delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat screenWidth = [GlobalConstants sharedInstance].screenWidth;
    long page_index = self.segmentController.selectedSegmentIndex;
    long currentPageX = screenWidth * page_index;
    if (scrollView.contentOffset.x >= currentPageX + screenWidth) {
        self.segmentController.selectedSegmentIndex++;
        [self displaySelectedView:self.segmentController.selectedSegmentIndex];
    }
    else if (scrollView.contentOffset.x <= currentPageX - screenWidth) {
        self.segmentController.selectedSegmentIndex--;
        [self displaySelectedView:self.segmentController.selectedSegmentIndex];
    }
}

#pragma mark - Badge notification methods

/**
 *  Badge notification name for processing list.
 */
- (NSString *)notificationNameForProcessingBadge {
    return PushNotificationBookingProcessingNotification;
}

/**
 *  Badge notification name for succeesed list.
 */
- (NSString *)notificationNameForSucceesedBadge {
    return PushNotificationBookingSucceedNotification;
}

/**
 *  Badge notification name for failed list.
 */
- (NSString *)notificationNameForFailedBadge {
    return PushNotificationBookingFailedNotification;
}

/**
 *  Add observer for badge notification.
 */
- (void)addBadgeNotificationObserver {
    // Processing badage.
    // add notification observer
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(observeBadgeNotification:)
     name:[self notificationNameForProcessingBadge]
     object:[NotificationBadgeController sharedInstance]];
    
    // check badge value
    NSUInteger processingBadgeValue =
    [[NotificationBadgeController sharedInstance]
     valueForBadgeWithBadgeName:[self notificationNameForProcessingBadge]];
    if (processingBadgeValue > 0) {
        [self setBadgeWithName:[self notificationNameForProcessingBadge]
                    badgeValue:processingBadgeValue];
    }
    
    if ([UserManager sharedInstance].userType != USER_TYPE_ADMIN) {
        // Succeed badage.
        // add notification observer
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(observeBadgeNotification:)
         name:[self notificationNameForSucceesedBadge]
         object:[NotificationBadgeController sharedInstance]];
        
        // check badge value
        NSUInteger succeedBadgeValue =
        [[NotificationBadgeController sharedInstance]
         valueForBadgeWithBadgeName:[self notificationNameForSucceesedBadge]];
        if (succeedBadgeValue > 0) {
            [self setBadgeWithName:[self notificationNameForSucceesedBadge]
                        badgeValue:succeedBadgeValue];
        }
        
        // Failed badage.
        // add notification observer
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(observeBadgeNotification:)
         name:[self notificationNameForFailedBadge]
         object:[NotificationBadgeController sharedInstance]];
        
        // check badge value
        NSUInteger failedBadgeValue =
        [[NotificationBadgeController sharedInstance]
         valueForBadgeWithBadgeName:[self notificationNameForFailedBadge]];
        if (failedBadgeValue > 0) {
            [self setBadgeWithName:[self notificationNameForFailedBadge]
                        badgeValue:failedBadgeValue];
        }
    }
}

/**
 *  Observe badge notification.
 */
- (void)observeBadgeNotification:(NSNotification *)notification {
    NotificationBadgeObject *badge = [notification userInfo][BadgeUserInfoKey];
    DDLogWarn(@"received badge object: %@", badge);
    [self setBadgeWithName:badge.name badgeValue:badge.value];
}

/**
 *  Add badge.
 */
- (void)setBadgeWithName:(NSString *)badgeName badgeValue:(NSUInteger)badgeValue {
    SSBadgeController *badageController = nil;
    if ([badgeName isEqualToString:[self notificationNameForProcessingBadge]]) {
        badageController = self.segmentController.badgeControllers[0];
    } else if ([badgeName isEqualToString:[self notificationNameForSucceesedBadge]]) {
        badageController = self.segmentController.badgeControllers[1];
    } else if ([badgeName isEqualToString:[self notificationNameForFailedBadge]]) {
        badageController = self.segmentController.badgeControllers[2];
    }
    
    if (badageController) {
        if (badgeValue > 0) {
            badageController.badgeValue = [@(badgeValue) stringValue];
            badageController.animated = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                badageController.animated = NO;
            });
        } else {
            badageController.badgeValue = nil;
        }
    }
}

@end
