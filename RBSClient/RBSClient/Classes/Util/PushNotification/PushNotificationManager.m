//
//  PushNotificationManager.m
//  RBSClient
//
//  Created by Shengsheng on 10/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "PushNotificationManager.h"
#import "AppTools.h"
#import "UserManager.h"
#import "AppDelegate.h"
#import "NotificationBadgeController.h"
#import "APIManager.h"
#import "ReviewStudentBookingViewController.h"

static NSString *const PushNotificationUserDefaultsDeviceTokenKey = @"PushNotificationUserDefaultsKey";

@implementation PushNotificationManager

+ (instancetype)sharedInstance {
    static PushNotificationManager *_singletonObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonObject = [[self alloc] init];
    });
    return _singletonObject;
}

- (instancetype)init {
    if (self = [super init]) {
        [self loadAPNToken];
    }
    return self;
}

- (void)setDeviceToken:(NSString *)apnToken {
    _apnToken = apnToken;
    [self saveAPNToken];
}

- (void)uploadAPNToken {
    UserManager *userManager = [UserManager sharedInstance];
    if (!userManager.currentUser) {
        return ;
    }
    [[APIManager sharedInstance]
     updateAPNTokenWithUserType:userManager.userTypeStr
     userId:userManager.userId
     apnToken:self.apnToken
     success:nil
     failure:nil
     timeout:nil];
}

- (void)notifyPushNotification:(NSDictionary *)pushData {
    NSString *type = [pushData stringNonNullObjectForKey:@"type"];
    if (type) {
        if ([type isEqualToString:@"roomBooking"]) {
            NSString *status = pushData[@"status"];
            if ([status isEqualToString:@"created"]) {
                // Student booking.
                [[NotificationBadgeController sharedInstance]
                 increaseValueWithBadgeName:PushNotificationMeStudentBookingNotification];
            } else if ([status isEqualToString:@"faculty_declined"]) {
                // Faculty declined.
                [[NotificationBadgeController sharedInstance]
                 decreaseValueWithBadgeName:PushNotificationBookingProcessingNotification];
                [[NotificationBadgeController sharedInstance]
                 increaseValueWithBadgeName:PushNotificationBookingFailedNotification];
            } else if ([status isEqualToString:@"faculty_approved"]) {
                // Faculty approved.
                [[NotificationBadgeController sharedInstance]
                 increaseValueWithBadgeName:PushNotificationBookingProcessingNotification];
            } else if ([status isEqualToString:@"admin_declined"]) {
                // Admin declined.
                [[NotificationBadgeController sharedInstance]
                 decreaseValueWithBadgeName:PushNotificationBookingProcessingNotification];
                [[NotificationBadgeController sharedInstance]
                 increaseValueWithBadgeName:PushNotificationBookingFailedNotification];
            } else if ([status isEqualToString:@"admin_approved"]) {
                // Admin approved.
                [[NotificationBadgeController sharedInstance]
                 decreaseValueWithBadgeName:PushNotificationBookingProcessingNotification];
                [[NotificationBadgeController sharedInstance]
                 increaseValueWithBadgeName:PushNotificationBookingSucceedNotification];
            } else if ([status isEqualToString:@"canceled"]) {
                // Canceled.
                // Do nothing.
            }
        }
    }
}

- (void)pushNotificationClicked:(NSDictionary *)pushData {
    NSString *type = [pushData stringNonNullObjectForKey:@"type"];
    if (type) {
        if ([type isEqualToString:@"roomBooking"]) {
            // Room booking.
            NSString *groupId = pushData[@"groupId"];
            ReviewStudentBookingViewController *vc = [ReviewStudentBookingViewController new];
            vc.studentBookingGroupId = groupId;
            [[self topMostNavigationController]
             pushPushNotificationViewController:vc animated:YES];
        }
    }
}

/**
 *  Retrieve the root navigation controller.
 */
- (RDVTabBarController *)rootNavigationController
{
    RDVTabBarController *navigationController =
    (RDVTabBarController *)([AppDelegate delegate].window.rootViewController);
    return navigationController;
}

/**
 *  Retrieve the top most navigation controller.
 */
- (CustomizeNavigationController *)topMostNavigationController {
    if (self.loginViewNavigationController) {
        return self.loginViewNavigationController;
    }
    RDVTabBarController *rootNavigationController = [self rootNavigationController];
    return (CustomizeNavigationController *)(rootNavigationController.viewControllers[rootNavigationController.selectedIndex]);
}

/**
 *  Save apn token.
 */
- (void)saveAPNToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.apnToken) {
        [defaults setObject:self.apnToken forKey:PushNotificationUserDefaultsDeviceTokenKey];
        [defaults synchronize];
    }
    
}

/**
 *  Load apn token.
 */
- (void)loadAPNToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.apnToken = [defaults objectForKey:PushNotificationUserDefaultsDeviceTokenKey];
}

@end
