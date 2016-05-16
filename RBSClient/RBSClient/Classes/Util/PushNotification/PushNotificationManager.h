//
//  PushNotificationManager.h
//  RBSClient
//
//  Created by Shengsheng on 10/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomizeNavigationController.h"
#import "Utils.h"

@interface PushNotificationManager : NSObject

@property(copy, nonatomic) NSString *apnToken;
@property(strong, nonatomic) UINavigationController *navigationController;
@property(weak, nonatomic) CustomizeNavigationController *loginViewNavigationController;

+ (instancetype)sharedInstance;

/**
 *  Upload APN token to server.
 */
- (void)uploadAPNToken;

/**
 *  Push notification comes, but user is within the app.
 */
- (void)notifyPushNotification:(NSDictionary *)pushData;

/**
 *  User clicked a push notification.
 */
- (void)pushNotificationClicked:(NSDictionary *)pushData;

/**
 *  Retrieve the top most navigation controller.
 */
- (CustomizeNavigationController *)topMostNavigationController;

@end
