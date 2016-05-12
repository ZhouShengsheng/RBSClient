//
//  APIManager.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "APIManager.h"
#import "URLManager.h"
#import "HttpPackage.h"
#import "Utils.h"

@implementation APIManager

+ (instancetype)sharedInstance {
    static APIManager *_singletonObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonObject = [[self alloc] init];
    });
    return _singletonObject;
}

#pragma mark - User API

- (void)loginWithType:(NSString *)type
               userId:(NSString *)userId
             password:(NSString *)password
              success:(void(^)(id jsonData))success
              failure:(void(^)(NSError *error))failure
              timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].loginURL;
    
    NSDictionary *params =
    @{@"type": type,
      @"id": userId,
      @"password": [password SHA1]};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)updateUserInfoWithType:(NSString *)type
                        userId:(NSString *)userId
                   designation:(NSString *)designation
                        office:(NSString *)office
                dormRoomNumber:(NSString *)dormRoomNumber
                         phone:(NSString *)phone
                       success:(void(^)(id jsonData))success
                       failure:(void(^)(NSError *error))failure
                       timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].updateUserInfoURL;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = type;
    params[@"id"] = userId;
    if (designation) {
        params[@"designation"] = [designation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if (office) {
        params[@"office"] = [office stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if (phone) {
        params[@"phone"] = [phone stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if (dormRoomNumber) {
        params[@"dormRoomNumber"] = [dormRoomNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)changePasswordWithType:(NSString *)type
                        userId:(NSString *)userId
                      password:(NSString *)password
                   newPassword:(NSString *)newPassword
                       success:(void(^)(id jsonData))success
                       failure:(void(^)(NSError *error))failure
                       timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].changePasswordURL;
    
    NSDictionary *params =
    @{@"type": type,
      @"id": userId,
      @"password": [password SHA1],
      @"newPassword": [newPassword SHA1]};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

#pragma mark - Room API

- (void)getRoomListWithBuilding:(NSString *)building
                       capacity:(NSUInteger)capacity
                  hasMultiMedia:(NSNumber *)hasMultiMedia
                  timeIntervals:(NSString *)timeIntervals
                      fromIndex:(NSInteger)fromIndex
                        success:(void(^)(id jsonData))success
                        failure:(void(^)(NSError *error))failure
                        timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].roomListURL;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fromIndex"] = [NSNumber numberWithInteger:fromIndex];
    if (building) {
        params[@"building"] = [building stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if (hasMultiMedia) {
        params[@"hasMultiMedia"] = hasMultiMedia;
    }
    params[@"timeIntervals"] = timeIntervals;
    params[@"capacity"] = @(capacity);
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)searchRoomListWithCondition:(NSString *)condition
                            success:(void(^)(id jsonData))success
                            failure:(void(^)(NSError *error))failure
                            timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].searchRoomListURL;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (condition) {
        params[@"condition"] = [condition stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)getRoomInfoWithUserType:(NSString *)userType
                         userId:(NSString *)userId
                       building:(NSString *)building
                         number:(NSString *)number
                        success:(void(^)(id jsonData))success
                        failure:(void(^)(NSError *error))failure
                        timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].roomInfoURL;
    
    NSDictionary *params =
    @{@"type": userType,
      @"id": userId,
      @"building": [building stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
      @"number": [number stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)setFavoriteRoomWithUserType:(NSString *)userType
                             userId:(NSString *)userId
                           building:(NSString *)building
                             number:(NSString *)number
                            success:(void(^)(id jsonData))success
                            failure:(void(^)(NSError *error))failure
                            timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].setFavoriteURL;
    
    NSDictionary *params =
    @{@"type": userType,
      @"id": userId,
      @"building": [building stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
      @"number": [number stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)unsetFavoriteRoomWithUserType:(NSString *)userType
                               userId:(NSString *)userId
                             building:(NSString *)building
                               number:(NSString *)number
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].unsetFavoriteURL;
    
    NSDictionary *params =
    @{@"type": userType,
      @"id": userId,
      @"building": [building stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
      @"number": [number stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)clearFavoriteRoomWithUserType:(NSString *)userType
                               userId:(NSString *)userId
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].clearFavoriteURL;
    
    NSDictionary *params =
    @{@"type": userType,
      @"id": userId};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)getFavoriteRoomListWithUserType:(NSString *)userType
                                 userId:(NSString *)userId
                              fromIndex:(NSUInteger)fromIndex
                                success:(void(^)(id jsonData))success
                                failure:(void(^)(NSError *error))failure
                                timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].favoriteListURL;
    
    NSDictionary *params =
    @{@"type": userType,
      @"id": userId,
      @"fromIndex": @(fromIndex)};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

#pragma mark - Room Booking API

- (void)bookRoomWithRoomBuilding:(NSString *)roomBuilding
                      roomNumber:(NSString *)roomNumber
                   applicantType:(NSString *)applicantType
                     applicantId:(NSString *)applicantId
                      bookReason:(NSString *)bookReason
                       facultyId:(NSString *)facultyId
                   timeIntervals:(NSString *)timeIntervals
                         success:(void(^)(id jsonData))success
                         failure:(void(^)(NSError *error))failure
                         timeout:(void(^)(void))timeout{
    NSString *url = [URLManager sharedInstance].bookRoomURL;
    
    NSDictionary *params =
    @{@"roomBuilding": [roomBuilding stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
      @"roomNumber": [roomNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
      @"applicantType": applicantType,
      @"applicantId": applicantId,
      @"bookReason": [bookReason stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
      @"facultyId": facultyId,
      @"timeIntervals": timeIntervals};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)getStudentBookingWithFacultyId:(NSString *)facultyId
                               success:(void(^)(id jsonData))success
                               failure:(void(^)(NSError *error))failure
                               timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].studentBookingListURL;
    
    NSDictionary *params =
    @{@"facultyId": facultyId};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)getRoomBookingInfoWithGroupId:(NSString *)groupId
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].roomBookingInfoURL;
    
    NSDictionary *params =
    @{@"groupId": groupId};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

#pragma mark - Supervisor API

- (void)checkIsSupervisorWithStudentId:(NSString *)studentId
                             facultyId:(NSString *)facultyId
                               success:(void(^)(id jsonData))success
                               failure:(void(^)(NSError *error))failure
                               timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].checkSupervisorURL;
    
    NSDictionary *params =
    @{@"studentId": studentId,
      @"facultyId": facultyId};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)getSupervisorListWithStudentId:(NSString *)studentId
                               success:(void(^)(id jsonData))success
                               failure:(void(^)(NSError *error))failure
                               timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].supervisorListURL;
    
    NSDictionary *params =
    @{@"studentId": studentId};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)addSupervisorWithStudentId:(NSString *)studentId
                         facultyId:(NSString *)facultyId
                           success:(void(^)(id jsonData))success
                           failure:(void(^)(NSError *error))failure
                           timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].addSupervisorURL;
    
    NSDictionary *params =
    @{@"studentId": studentId,
      @"facultyId": facultyId};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)removeSupervisorWithStudentId:(NSString *)studentId
                            facultyId:(NSString *)facultyId
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].removeSupervisorURL;
    
    NSDictionary *params =
    @{@"studentId": studentId,
      @"facultyId": facultyId};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

- (void)searchSupervisorWithCondition:(NSString *)condition
                              success:(void(^)(id jsonData))success
                              failure:(void(^)(NSError *error))failure
                              timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].searchSupervisorURL;
    
    NSDictionary *params =
    @{@"condition": [condition stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:params
     success:success
     failure:failure
     timeout:timeout];
}

@end
