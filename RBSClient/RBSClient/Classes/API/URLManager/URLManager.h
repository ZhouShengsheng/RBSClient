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

#pragma mark - User

/**
 *  Login url.
 */
@property(copy, readonly, nonatomic) NSString *loginURL;

#pragma mark - Room

/**
 *  Get room list url.
 */
@property(copy, readonly, nonatomic) NSString *roomListURL;

/**
 *  Search room list url.
 */
@property(copy, readonly, nonatomic) NSString *searchRoomListURL;

/**
 *  Get room info url.
 */
@property(copy, readonly, nonatomic) NSString *roomInfoURL;

/**
 *  Set favorite url.
 */
@property(copy, readonly, nonatomic) NSString *setFavoriteURL;

/**
 *  Unset favorite url.
 */
@property(copy, readonly, nonatomic) NSString *unsetFavoriteURL;

#pragma mark - Room booking
/**
 *  Unset favorite url.
 */
@property(copy, readonly, nonatomic) NSString *bookRoomURL;

+ (instancetype)sharedInstance;

@end
