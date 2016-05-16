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
 *  Logout url.
 */
@property(copy, readonly, nonatomic) NSString *logoutURL;

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
 *  Book room url.
 */
@property(copy, readonly, nonatomic) NSString *bookRoomURL;

/**
 *  Cancel booking room url.
 */
@property(copy, readonly, nonatomic) NSString *cancelBookingURL;

/**
 *  Student booking list url.
 */
@property(copy, readonly, nonatomic) NSString *studentBookingListURL;

/**
 *  Detailed booking info url.
 */
@property(copy, readonly, nonatomic) NSString *roomBookingInfoURL;

/**
 *  Approve room booking url.
 */
@property(copy, readonly, nonatomic) NSString *approveRoomBookingURL;

/**
 *  Decline room booking url.
 */
@property(copy, readonly, nonatomic) NSString *declineRoomBookingURL;

/**
 *  Processing room booking list url.
 */
@property(copy, readonly, nonatomic) NSString *processingRoomBookingListURL;

/**
 *  Approved room booking list url.
 */
@property(copy, readonly, nonatomic) NSString *approvedRoomBookingListURL;

/**
 *  Declined room booking list url.
 */
@property(copy, readonly, nonatomic) NSString *declinedRoomBookingListURL;

/**
 *  History room booking list url.
 */
@property(copy, readonly, nonatomic) NSString *historyRoomBookingListURL;

/**
 *  Admin room booking proccessing list url.
 */
@property(copy, readonly, nonatomic) NSString *adminRoomBookingProcessingListURL;

/**
 *  Admin room booking proccessed list url.
 */
@property(copy, readonly, nonatomic) NSString *adminRoomBookingProcessedListURL;

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

#pragma mark - Push notification
/**
 *  Update apn token url.
 */
@property(copy, readonly, nonatomic) NSString *updateAPNTokenURL;

+ (instancetype)sharedInstance;

@end
