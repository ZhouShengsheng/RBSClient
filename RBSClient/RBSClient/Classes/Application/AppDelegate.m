//
//  AppDelegate.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "AppDelegate.h"
#import "Utils.h"
#import "PushNotificationManager.h"
#import "MainController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Get the shared delegate
//=========================================================================================
// Get the shared delegate
//=========================================================================================
+ (AppDelegate *)delegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    initDDLogger();
    
    [GlobalConstants sharedInstance];
    
    [self pushNotificationInitialize];
    
    // save the notification data
    [MainController sharedInstance].notificationData = [launchOptions
                             objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push notification service

/**
 *  Initialize push notification.
 */
- (void)pushNotificationInitialize {
    UIApplication *application = [UIApplication sharedApplication];
    [application registerUserNotificationSettings:
     [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * tempToken = [deviceToken description];
    NSString *token = [tempToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [[token componentsSeparatedByString:@" "] componentsJoinedByString:@"" ];
    DDLogError(@"Device token: %@", token);
    
    PushNotificationManager *pushNotificationManager = [PushNotificationManager sharedInstance];
    pushNotificationManager.apnToken = token;
    [pushNotificationManager uploadAPNToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    DDLogError(@"%s", __func__);
    DDLogError(@"notification: %@", userInfo);
    
    if (application.applicationState == UIApplicationStateInactive) {
        [[PushNotificationManager sharedInstance]
         pushNotificationClicked:userInfo];
        DDLogError(@"User clicked notification!");
    } else if (application.applicationState == UIApplicationStateActive) {
        DDLogError(@"Notify notification!");
        [[PushNotificationManager sharedInstance]
         notifyPushNotification:userInfo];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        NSString *message = userInfo[@"aps"][@"alert"];
        localNotification.alertBody = message;
        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DDLogError(@"Registfail: %@",error);
}

@end
