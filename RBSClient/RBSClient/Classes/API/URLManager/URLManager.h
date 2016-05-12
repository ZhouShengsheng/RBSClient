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

/**
 *  Update user info url.
 */
@property(copy, readonly, nonatomic) NSString *updateUserInfoURL;

/**
 *  Change password url.
 */
@property(copy, readonly, nonatomic) NSString *changePasswordURL;

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

/**
 *  Clear favorite url.
 */
@property(copy, readonly, nonatomic) NSString *clearFavoriteURL;

/**
 *  Get favorite list url.
 */
@property(copy, readonly, nonatomic) NSString *favoriteListURL;

#pragma mark - Room booking
/**
 *  Unset favorite url.
 */
@property(copy, readonly, nonatomic) NSString *bookRoomURL;

/**
 *  Student booking list url.
 */
@property(copy, readonly, nonatomic) NSString *studentBookingListURL;

/**
 *  Detailed booking info url.
 */
@property(copy, readonly, nonatomic) NSString *roomBookingInfoURL;

#pragma mark - Supervisor
/**
 *  Check supervisor url.
 */
@property(copy, readonly, nonatomic) NSString *checkSupervisorURL;

/**
 *  Get supervisor list url.
 */
@property(copy, readonly, nonatomic) NSString *supervisorListURL;

/**
 *  Add supervisor url.
 */
@property(copy, readonly, nonatomic) NSString *addSupervisorURL;

/**
 *  Remove supervisor url.
 */
@property(copy, readonly, nonatomic) NSString *removeSupervisorURL;

/**
 *  Search supervisor url.
 */
@property(copy, readonly, nonatomic) NSString *searchSupervisorURL;

+ (instancetype)sharedInstance;

@end
