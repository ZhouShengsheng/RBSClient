//
//  MainController.m
//  RBSClient
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "MainController.h"
#import "AppDelegate.h"
#import "CustomizeNavigationController.h"
#import "RDVTabBarItem.h"
#import "Utils.h"
#import "NotificationBadgeController.h"
#import "PushNotificationManager.h"
#import "UserManager.h"

@implementation MainController

+ (instancetype)sharedInstance {
    static MainController *_singletonObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonObject = [[self alloc] init];
    });
    return _singletonObject;
}

- (void)setupRootViewController {
    if (!self.tabBarController) {
        [self setupViewControllers];
        self.tabBarController.delegate = self;
        [self customizeInterface];
        [self addBadgeNotificationObserver];
    }
    
    [AppDelegate delegate].window.rootViewController = self.tabBarController;
    
    if(self.notificationData)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[PushNotificationManager sharedInstance]
             pushNotificationClicked:self.notificationData];
            self.notificationData = nil;
        });
    }
}

- (void)removeRootViewController {
    self.tabBarController = nil;
    [AppDelegate delegate].window.rootViewController = self.loginController;
    [self.loginController logout];
}

- (void)setupViewControllers {
    UIStoryboard *roomStoryboard = [UIStoryboard storyboardWithName:@"Room"
                                                             bundle:[NSBundle mainBundle]];
    CustomizeNavigationController *roomNavigationController = [roomStoryboard
                                                               instantiateViewControllerWithIdentifier:@"RoomNavigationController"];
    UIStoryboard *bookingStoryboard = [UIStoryboard storyboardWithName:@"Booking"
                                                             bundle:[NSBundle mainBundle]];
    CustomizeNavigationController *bookingNavigationController = [bookingStoryboard
                                                               instantiateViewControllerWithIdentifier:@"BookingNavigationController"];
    UIStoryboard *favoriteStoryboard = [UIStoryboard storyboardWithName:@"Favorite"
                                                           bundle:[NSBundle mainBundle]];
    CustomizeNavigationController *favoriteNavigationController = [favoriteStoryboard
                                                             instantiateViewControllerWithIdentifier:@"FavoriteNavigationController"];
    UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"Me"
                                                             bundle:[NSBundle mainBundle]];
    CustomizeNavigationController *meNavigationController = [meStoryboard
                                                               instantiateViewControllerWithIdentifier:@"MeNavigationController"];
    
    self.tabBarController = [[RDVTabBarController alloc] init];
    [self.tabBarController setViewControllers:@[roomNavigationController,
                                                bookingNavigationController,
                                                favoriteNavigationController,
                                                meNavigationController]];
    self.tabBarController.delegate = self;
    
    [self customizeTabBarController];
}

- (void)customizeTabBarController {
    self.tabBarController.tabBar.translucent = YES;
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    // add shadow
    self.tabBarController.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBarController.tabBar.layer.shadowOffset = CGSizeMake(0, -2);
    self.tabBarController.tabBar.layer.shadowOpacity = 0.25;
    
    NSArray *tabBarItems = @[@"教室", @"申请", @"收藏", @"我的"];
    NSArray *imageItems = @[@"icon_roomTab", @"icon_bookingTab", @"icon_favoriteTab", @"icon_meTab"];
    
    NSArray *items = [[self.tabBarController tabBar] items];
    NSUInteger count = tabBarItems.count;
    for (NSUInteger index = 0; index < count; index++) {
        RDVTabBarItem *item = items[index];
        item.title = tabBarItems[index];
        
        [item setSelectedTitleAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName: [UIColor themeColor]}];
        
        [item setUnselectedTitleAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                             NSForegroundColorAttributeName: [UIColor unselectedColor]}];
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Selected",
                                                      imageItems[index]]];
        UIImage *unselectedimage = [UIImage imageNamed:imageItems[index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
    }
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTintColor: [UIColor themeColor]];
    
    UIToolbar *toolBarAppearance = [UIToolbar appearance];
    [toolBarAppearance setTintColor: [UIColor themeColor]];
    
    [[UITableViewCell appearance] setTintColor:[UIColor labelTextColor]];
}

#pragma mark - Badge notification methods

/**
 *  Booking badge notification name for booking tab.
 */
- (NSString *)notificationNameForBooking {
    return PushNotificationBookingNotification;
}

/**
 *  Booking badge notification name for me tab.
 */
- (NSString *)notificationNameForMe {
    return PushNotificationMeNotification;
}

/**
 *  Add observer for badge notification.
 */
- (void)addBadgeNotificationObserver {
    // add notification observer
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(observeBadgeNotification:)
     name:[self notificationNameForBooking]
     object:[NotificationBadgeController sharedInstance]];
    
    // check badge value
    NSUInteger bookingBadgeValue =
    [[NotificationBadgeController sharedInstance]
     valueForBadgeWithBadgeName:[self notificationNameForBooking]];
    if (bookingBadgeValue > 0) {
        [self addBadgeWithBadgeName:[self notificationNameForBooking] badgeValue:bookingBadgeValue];
    }
    
    // Faculty.
    if ([UserManager sharedInstance].userType == USER_TYPE_FACULTY) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(observeBadgeNotification:)
         name:[self notificationNameForMe]
         object:[NotificationBadgeController sharedInstance]];
        
        NSUInteger meBadgeValue =
        [[NotificationBadgeController sharedInstance]
         valueForBadgeWithBadgeName:[self notificationNameForMe]];
        if (meBadgeValue > 0) {
            [self addBadgeWithBadgeName:[self notificationNameForMe] badgeValue:meBadgeValue];
        }
    }
}

/**
 *  Observe badge notification.
 */
- (void)observeBadgeNotification:(NSNotification *)notification {
    NotificationBadgeObject *badge = [notification userInfo][BadgeUserInfoKey];
    DDLogWarn(@"received badge object: %@", badge);
    if (badge.value > 0) {
        [self addBadgeWithBadgeName:badge.name badgeValue:badge.value];
    } else {
        [self removeBadgeWithBadgeName:badge.name];
    }
}

/**
 *  Add badge.
 */
- (void)addBadgeWithBadgeName:(NSString *)badgeName badgeValue:(NSUInteger)badgeValue {
    if ([badgeName isEqualToString:[self notificationNameForBooking]]) {
        RDVTabBarItem *tabbarItem = self.tabBarController.tabBar.items[1];
        tabbarItem.badgeValue = [@(badgeValue) stringValue];
    } else if ([badgeName isEqualToString:[self notificationNameForMe]]) {
        RDVTabBarItem *tabbarItem = self.tabBarController.tabBar.items[3];
        tabbarItem.badgeValue = [@(badgeValue) stringValue];
    }
    
}

/**
 *  Remove badge from.
 */
- (void)removeBadgeWithBadgeName:(NSString *)badgeName {
    if ([badgeName isEqualToString:[self notificationNameForBooking]]) {
        RDVTabBarItem *tabbarItem = self.tabBarController.tabBar.items[1];
        tabbarItem.badgeValue = nil;
    } else if ([badgeName isEqualToString:[self notificationNameForMe]]) {
        RDVTabBarItem *tabbarItem = self.tabBarController.tabBar.items[3];
        tabbarItem.badgeValue = nil;
    }
}

@end
