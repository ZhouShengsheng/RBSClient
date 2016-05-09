//
//  MainController.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "MainController.h"
#import "AppDelegate.h"
#import "CustomizeNavigationController.h"
#import "RDVTabBarItem.h"
#import "Utils.h"

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
        //[self addBadgeNotificationObserver];
    }
    
    [AppDelegate delegate].window.rootViewController = self.tabBarController;
    
//    if(self.notificationData)
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //Handle notification
//            //DDLogError(@"notificationData: %@", self.notificationData);
//            [[PushNotificationManager sharedInstance]
//             pushNotificationClicked:self.notificationData];
//            self.notificationData = nil;
//        });
//    }
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
    UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"Me"
                                                             bundle:[NSBundle mainBundle]];
    CustomizeNavigationController *meNavigationController = [meStoryboard
                                                               instantiateViewControllerWithIdentifier:@"MeNavigationController"];
    
    self.tabBarController = [[RDVTabBarController alloc] init];
    [self.tabBarController setViewControllers:@[roomNavigationController,
                                           bookingNavigationController,
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
    
    NSArray *tabBarItems = @[@"教室", @"申请", @"我的"];
    NSArray *imageItems = @[@"icon_roomTab", @"icon_bookingTab", @"icon_meTab"];
    
    NSArray *items = [[self.tabBarController tabBar] items];
    int count = tabBarItems.count;
    for (int index = 0; index < count; index++) {
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

@end
