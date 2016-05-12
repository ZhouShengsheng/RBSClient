//
//  APIManager.h
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - User API

/**
 *  Login.
 */
- (void)loginWithType:(NSString *)type
               userId:(NSString *)userId
             password:(NSString *)password
              success:(void(^)(id jsonData))success
              failure:(void(^)(NSError *error))failure
              timeout:(void(^)(void))timeout;

/**
 *  Update user info.
 */
- (void)updateUserInfoWithType:(NSString *)type
                        userId:(NSString *)userId
                   designation:(NSString *)designation
                        office:(NSString *)office
                dormRoomNumber:(NSString *)dormRoomNumber
                         phone:(NSString *)phone
                       success:(void(^)(id jsonData))success
                       failure:(void(^)(NSError *error))failure
                       timeout:(void(^)(void))timeout;

/**
 *  Change password.
 */
- (void)changePasswordWithType:(NSString *)type
                        userId:(NSString *)userId
                      password:(NSString *)password
                   newPassword:(NSString *)newPassword
                       success:(void(^)(id jsonData))success
                       failure:(void(^)(NSError *error))failure
                       timeout:(void(^)(void))timeout;

#pragma mark - Room API

/**
 *  Get room list.
 *  @param building 
 *      软件楼 or 图书馆, pass nil to retrieve both.
 *  @param fromIndex 
 *      -1 to retrieve all.
 */
- (void)getRoomListWithBuilding:(NSString *)building
                       capacity:(NSUInteger)capacity
                  hasMultiMedia:(NSNumber *)hasMultiMedia
                  timeIntervals:(NSString *)timeIntervals
                      fromIndex:(NSInteger)fromIndex
                        success:(void(^)(id jsonData))success
                        failure:(void(^)(NSError *error))failure
                        timeout:(void(^)(void))timeout;

/**
 *  Search room list.
 *
 *  @param condition
 *      Search condition. Eg. 软件楼101, 软件楼1 or 图书馆20.
 */
- (void)searchRoomListWithCondition:(NSString *)condition
                            success:(void(^)(id jsonData))success
                            failure:(void(^)(NSError *error))failure
                            timeout:(void(^)(void))timeout;

/**
 *  Get room info.
 */
- (void)getRoomInfoWithUserType:(NSString *)userType
                         userId:(NSString *)userId
                       building:(NSString *)building
                         number:(NSString *)number
                        success:(void(^)(id jsonData))success
                        failure:(void(^)(NSError *error))failure
                        timeout:(void(^)(void))timeout;

/**
 *  Set favorite of a room.
 */
- (void)setFavoriteRoomWithUserType:(NSString *)userType
                             userId:(NSString *)userId
                           building:(NSString *)building
                             number:(NSString *)number
                            success:(void(^)(id jsonData))success
                            failure:(void(^)(NSError *error))failure
                            timeout:(void(^)(void))timeout;

/**
 *  Unset favorite of a room.
 */
- (void)unsetFavoriteRoomWithUserType:(NSString *)userType
                               userId:(NSString *)userId
                             building:(NSString *)building
                               number:(NSString *)number
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout;

/**
 *  Clear favorite.
 */
- (void)clearFavoriteRoomWithUserType:(NSString *)userType
                               userId:(NSString *)userId
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout;

/**
 *  Get favorite list.
 */
- (void)getFavoriteRoomListWithUserType:(NSString *)userType
                                 userId:(NSString *)userId
                              fromIndex:(NSUInteger)fromIndex
                                success:(void(^)(id jsonData))success
                                failure:(void(^)(NSError *error))failure
                                timeout:(void(^)(void))timeout;

#pragma mark - Room Booking API

/**
 *  Book room.
 */
- (void)bookRoomWithRoomBuilding:(NSString *)roomBuilding
                      roomNumber:(NSString *)roomNumber
                   applicantType:(NSString *)applicantType
                     applicantId:(NSString *)applicantId
                      bookReason:(NSString *)bookReason
                       facultyId:(NSString *)facultyId
                   timeIntervals:(NSString *)timeIntervals
                         success:(void(^)(id jsonData))success
                         failure:(void(^)(NSError *error))failure
                         timeout:(void(^)(void))timeout;

/**
 *  Get student booking list.
 */
- (void)getStudentBookingWithFacultyId:(NSString *)facultyId
                               success:(void(^)(id jsonData))success
                               failure:(void(^)(NSError *error))failure
                               timeout:(void(^)(void))timeout;

/**
 *  Get detailed booking info.
 */
- (void)getRoomBookingInfoWithGroupId:(NSString *)groupId
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout;

#pragma mark - Supervisor API

/**
 *  Check the faculty is the student's supervisor.
 */
- (void)checkIsSupervisorWithStudentId:(NSString *)studentId
                             facultyId:(NSString *)facultyId
                               success:(void(^)(id jsonData))success
                               failure:(void(^)(NSError *error))failure
                               timeout:(void(^)(void))timeout;

/**
 *  Get supervisor list.
 */
- (void)getSupervisorListWithStudentId:(NSString *)studentId
                               success:(void(^)(id jsonData))success
                               failure:(void(^)(NSError *error))failure
                               timeout:(void(^)(void))timeout;

/**
 *  Add supervisor.
 */
- (void)addSupervisorWithStudentId:(NSString *)studentId
                         facultyId:(NSString *)facultyId
                           success:(void(^)(id jsonData))success
                           failure:(void(^)(NSError *error))failure
                           timeout:(void(^)(void))timeout;

/**
 *  Remove supervisor.
 */
- (void)removeSupervisorWithStudentId:(NSString *)studentId
                            facultyId:(NSString *)facultyId
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout;

/**
 *  Search supervisor.
 */
- (void)searchSupervisorWithCondition:(NSString *)condition
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout;



@end
