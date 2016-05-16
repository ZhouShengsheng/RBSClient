//
//  NotificationBadgeController.m
//  RBSClient
//
//  Created by Shengsheng on 15/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "NotificationBadgeController.h"
#import "JTTree.h"
#import "DDLog.h"

/**
 *  User defaults key.
 */
static NSString *const UserDefaultsBadgeKey = @"BadgeTree";

@interface NotificationBadgeController ()

@property(strong, nonatomic) JTTree *rootTree;

@end

@implementation NotificationBadgeController

+ (instancetype)sharedInstance {
    static NotificationBadgeController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self initBadgeTree];
    }
    return self;
}

- (void)initBadgeTree {
    // init root
    self.rootTree = [JTTree new];
    self.rootTree.object = [[NotificationBadgeObject alloc]
                            initWithName:PushNotificationRootNotification];
    
    // root (booking, me)
    [self.rootTree insertChildObject:[[NotificationBadgeObject alloc]
                             initWithName:PushNotificationBookingNotification]
                    atIndex:0];
    [self.rootTree insertChildObject:[[NotificationBadgeObject alloc]
                             initWithName:PushNotificationMeNotification]
                    atIndex:1];
    
    // room (processing, succeed, failed)
    JTTree *bookingChild = [self.rootTree childAtIndex:0];
    [bookingChild insertChildObject:[[NotificationBadgeObject alloc]
                                     initWithName:PushNotificationBookingProcessingNotification]
                            atIndex:0];
    [bookingChild insertChildObject:[[NotificationBadgeObject alloc]
                                     initWithName:PushNotificationBookingSucceedNotification]
                            atIndex:1];
    [bookingChild insertChildObject:[[NotificationBadgeObject alloc]
                                     initWithName:PushNotificationBookingFailedNotification]
                            atIndex:2];
    
    // me (studentBooking)
    JTTree *meChild = [self.rootTree childAtIndex:1];
    [meChild insertChildObject:[[NotificationBadgeObject alloc]
                                  initWithName:PushNotificationMeStudentBookingNotification]
                         atIndex:0];
    
    [self loadTreeFromUserDefaults];
    // traverse
    [self.rootTree enumerateDescendantsWithOptions:JTTreeTraversalDepthFirstPreOrder
                               usingBlock:^(JTTree *descendant, BOOL *stop) {
                                   NotificationBadgeObject *badge = descendant.object;
                                   DDLogError(@"%@", badge);
                               }];
}

/**
 *  Load saved tree from user defaults.
 */
- (void)loadTreeFromUserDefaults {
    DDLogError(@"%s", __func__);
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(saveTreeToUserDefaults)
     name:UIApplicationWillResignActiveNotification
     object:nil];
    
    NSMutableArray *badgeArray = [[NSUserDefaults standardUserDefaults]
                           objectForKey:UserDefaultsBadgeKey];
    if (!badgeArray) {
        return ;
    }
    __block int i = 0;
    [self.rootTree
     enumerateDescendantsWithOptions:JTTreeTraversalDepthFirstPreOrder
     usingBlock:^(JTTree *descendant, BOOL *stop) {
         descendant.object = [NSKeyedUnarchiver unarchiveObjectWithData:badgeArray[i]];
         i++;
     }];
}

/**
 *  Save current tree to user defaults.
 */
- (void)saveTreeToUserDefaults {
    DDLogError(@"%s", __func__);
    if (!self.rootTree) {
        return ;
    }
    NSMutableArray *badgeArray = [NSMutableArray array];
    [self.rootTree
     enumerateDescendantsWithOptions:JTTreeTraversalDepthFirstPreOrder
     usingBlock:^(JTTree *descendant, BOOL *stop) {
         NSData *archivedBadge = [NSKeyedArchiver archivedDataWithRootObject:descendant.object];
         [badgeArray addObject:archivedBadge];
     }];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:badgeArray forKey:UserDefaultsBadgeKey];
    [userDefaults synchronize];
}

- (void)increaseValueWithBadgeName:(NSString *)badgeName {
    DDLogError(@"%s: %@", __func__, badgeName);
    [self.rootTree
     enumerateDescendantsWithOptions:JTTreeTraversalDepthFirstPreOrder
     usingBlock:^(JTTree *descendant, BOOL *stop) {
         NotificationBadgeObject *badge = descendant.object;
         DDLogError(@"badge: %@", badge);
         if ([badge.name isEqualToString:badgeName]) {
             DDLogError(@"founded %@", badgeName);
             *stop = YES;
             badge.value++;
             [self sendNotificationWithNotificationName:badgeName
                                              andObject:badge];
             while (descendant.parent) {
                 NotificationBadgeObject *parentBadge = descendant.parent.object;
                 DDLogError(@"parentBadge: %@", parentBadge);
                 parentBadge.value++;
                 [self sendNotificationWithNotificationName:parentBadge.name
                                                  andObject:parentBadge];
                 
                 descendant = descendant.parent;
             }
         }
     }];
}

- (void)decreaseValueWithBadgeName:(NSString *)badgeName {
    DDLogError(@"%s: %@", __func__, badgeName);
    [self.rootTree
     enumerateDescendantsWithOptions:JTTreeTraversalDepthFirstPreOrder
     usingBlock:^(JTTree *descendant, BOOL *stop) {
         NotificationBadgeObject *badge = descendant.object;
         DDLogError(@"badge: %@", badge);
         if ([badge.name isEqualToString:badgeName]) {
             DDLogError(@"founded %@", badgeName);
             *stop = YES;
             if (badge.value > 0) {
                 badge.value--;
                 [self sendNotificationWithNotificationName:badgeName
                                                  andObject:badge];
                 while (descendant.parent) {
                     NotificationBadgeObject *parentBadge = descendant.parent.object;
                     DDLogError(@"parentBadge: %@", parentBadge);
                     if (parentBadge.value > 0) {
                         parentBadge.value--;
                         [self sendNotificationWithNotificationName:parentBadge.name
                                                          andObject:parentBadge];
                     }
                     descendant = descendant.parent;
                 }
             }
         }
     }];
}

- (void)clearValueWithBadgeName:(NSString *)badgeName {
    DDLogError(@"%s: %@", __func__, badgeName);
    [self.rootTree
     enumerateDescendantsWithOptions:JTTreeTraversalDepthFirstPreOrder
     usingBlock:^(JTTree *descendant, BOOL *stop) {
         NotificationBadgeObject *badge = descendant.object;
         DDLogError(@"badge: %@", badge);
         if ([badge.name isEqualToString:badgeName]) {
             DDLogError(@"founded %@", badgeName);
             *stop = YES;
             if (badge.value > 0) {
                 NSUInteger totalValue = badge.value;
                 badge.value = 0;
                 [self sendNotificationWithNotificationName:badgeName
                                                  andObject:badge];
                 while (descendant.parent) {
                     NotificationBadgeObject *parentBadge = descendant.parent.object;
                     DDLogError(@"parentBadge: %@", parentBadge);
                     if (parentBadge.value > 0) {
                         parentBadge.value -= totalValue;
                         [self sendNotificationWithNotificationName:parentBadge.name
                                                          andObject:parentBadge];
                     }
                     descendant = descendant.parent;
                 }
             }
         }
     }];
}

- (NSUInteger)valueForBadgeWithBadgeName:(NSString *)badgeName {
    __block NSUInteger value = 0;
    [self.rootTree
     enumerateDescendantsWithOptions:JTTreeTraversalDepthFirstPreOrder
     usingBlock:^(JTTree *descendant, BOOL *stop) {
         NotificationBadgeObject *badge = descendant.object;
         DDLogError(@"badge: %@", badge);
         if ([badge.name isEqualToString:badgeName]) {
             DDLogError(@"founded %@", badgeName);
             *stop = YES;
             value = badge.value;
         }
     }];
    return value;
}

/**
 *  Send notifications.
 */
- (void)sendNotificationWithNotificationName:(NSString *)notificationName
                                   andObject:(NotificationBadgeObject *)badgeObject {
    DDLogError(@"send notification: (%@, %@)", notificationName, badgeObject);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:notificationName
     object:self
     userInfo:@{BadgeUserInfoKey: badgeObject}];
}

@end
