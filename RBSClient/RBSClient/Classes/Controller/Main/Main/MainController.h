//
//  MainController.h
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDVTabBarController.h"

@interface MainController : NSObject <RDVTabBarControllerDelegate>

@property (strong, nonatomic) RDVTabBarController *tabBarController;

+ (instancetype)sharedInstance;

/**
 *  Set up and show root view controller.
 */
- (void)setupRootViewController;

@end
