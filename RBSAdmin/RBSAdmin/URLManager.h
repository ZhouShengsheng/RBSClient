//
//  URLManager.h
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Server address.
 */
static const NSString *server = @"http://192.168.11.13";

/**
 *  Server port.
 */
static const unsigned int port = 9999;

/**
 *  API urls stored here.
 */
@interface URLManager : NSObject

/**
 *  Admin login url.
 */
@property(copy, readonly, nonatomic) NSString *adminLoginURL;

+ (instancetype)sharedInstance;

@end
