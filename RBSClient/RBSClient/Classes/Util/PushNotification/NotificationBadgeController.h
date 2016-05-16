//
//  NotificationBadgeController.h
//  RBSClient
//
//  Created by Shengsheng on 15/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationBadgeObject.h"

// Notification names.
static NSString *const PushNotificationRootNotification = @"Root";
static NSString *const PushNotificationBookingNotification = @"Booking";
static NSString *const PushNotificationBookingProcessingNotification = @"BookingProcessing";
static NSString *const PushNotificationBookingSucceedNotification = @"BookingSucceed";
static NSString *const PushNotificationBookingFailedNotification = @"BookingFailed";
static NSString *const PushNotificationMeNotification = @"Me";
static NSString *const PushNotificationMeStudentBookingNotification = @"MeStudentBooking";

/**
 *  User info key.
 */
static NSString *const BadgeUserInfoKey = @"badgeObject";

@interface NotificationBadgeController : NSObject

+ (instancetype)sharedInstance;

/**
 *  Increase value from a child with specific badge name.
 */
- (void)increaseValueWithBadgeName:(NSString *)badgeName;

/**
 *  Decrease value from a child with specific badge name.
 */
- (void)decreaseValueWithBadgeName:(NSString *)badgeName;

/**
 *  Clear value from a child with specific badge name.
 */
- (void)clearValueWithBadgeName:(NSString *)badgeName;

/**
 *  Retrieve value of a badge with specific badge name.
 */
- (NSUInteger)valueForBadgeWithBadgeName:(NSString *)badgeName;

@end
