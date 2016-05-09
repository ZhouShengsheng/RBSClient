//
//  CustomizeNavigationController.h
//  iJuGou
//
//  Created by Hu Weizheng on 11/1/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizeNavigationController : UINavigationController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

/**
 *  Push view controller which comes from push notification.
 */
- (void)pushPushNotificationViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
