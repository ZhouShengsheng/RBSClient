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
static const NSString *server = @"http://www.zss-rbs.site:8080/RBSServer";

/**
 *  API urls stored here.
 */
@interface URLManager : NSObject

/**
 *  Login url.
 */
@property(copy, readonly, nonatomic) NSString *loginURL;

/**
 *  Get room list url.
 */
@property(copy, readonly, nonatomic) NSString *roomListURL;

+ (instancetype)sharedInstance;

@end
