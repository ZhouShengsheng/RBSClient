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

@interface BookingListViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property(assign, nonatomic) CGFloat lastContentOffset;
@property(assign, nonatomic) long previousIndex;
@property(assign, nonatomic) long currentIndex;

@property(strong, nonatomic) HMSegmentedControl *segmentController;
@property(strong, nonatomic) UIScrollView *contentScrollView;
@property(strong, nonatomic) NSArray *controllers;

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
            
            //[self addBadgeNotificationObserver];
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
    UIViewController *currentController = [self.controllers objectAtIndex:pageIndex];
    self.title = currentController.title;
    
    // init view
    if ([currentController conformsToProtocol:@protocol(RecyclableViewController)]) {
        [(id<RecyclableViewController>)currentController initializeView];
    }
    
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
        UIViewController *currentController = [self.controllers objectAtIndex:i];
        if (i == pageIndex) {
            if ([currentController conformsToProtocol:@protocol(RecyclableViewController)]) {
                [(id<RecyclableViewController>)currentController currentScrollView].scrollsToTop = YES;
            }
        }
        else {
            if ([currentController conformsToProtocol:@protocol(RecyclableViewController)]) {
                [(id<RecyclableViewController>)currentController currentScrollView].scrollsToTop = NO;
            }
        }
    }
}

#pragma mark - Segmented controller delegate method

- (void)segmentedControllerValueChanged:(HMSegmentedControl *)segmentedControl {
    // if has badge value, refresh user message
//    if (self.badgeController.badgeValue &&
//        segmentedControl.selectedSegmentIndex == 1 &&
//        self.followViewController) {
//        [self.followViewController refresh];
//    } else if (currentIndex == segmentedControl.selectedSegmentIndex) {
//        return ;
//    }
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

@end
