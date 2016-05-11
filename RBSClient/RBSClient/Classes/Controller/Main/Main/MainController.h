//
//  MainController.h
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDVTabBarController.h"
#import "LoginViewController.h"

@interface MainController : NSObject <RDVTabBarControllerDelegate>

@property (strong, nonatomic) RDVTabBarController *tabBarController;
@property (strong, nonatomic) LoginViewController *loginController;

+ (instancetype)sharedInstance;

/**
 *  Set up and show root view controller.
 */
- (void)setupRootViewController;

/**
 *  Remove root view controller.
 */
- (void)removeRootViewController;

@end
