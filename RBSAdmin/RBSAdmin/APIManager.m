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
//=========================================================================================
// User API
//=========================================================================================
/**
 *  Login.
 */
- (void)loginWithType:(NSString *)type
               userId:(NSString *)userId
             password:(NSString *)password
              success:(void(^)(id jsonData))success
              failure:(void(^)(NSError *error))failure
              timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].loginURL;
    
    NSDictionary *parms =
    @{@"type": type,
      @"id": userId,
      @"password": [password SHA1]};
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:parms
     success:success
     failure:failure
     timeout:timeout];
}

#pragma mark - Room API
//=========================================================================================
// Room API
//=========================================================================================
/**
 *  Get room list.
 *  @param building
 *      软件楼 or 图书馆, pass nil to retrieve both.
 *  @param fromIndex
 *      -1 to retrieve all.
 */
- (void)getRoomListWithBuilding:(NSString *)building
                      fromIndex:(NSInteger)fromIndex
                        success:(void(^)(id jsonData))success
                        failure:(void(^)(NSError *error))failure
                        timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].roomListURL;
    
    NSDictionary *parms;
    if (building) {
       parms = @{@"building": building,
                 @"fromIndex": [NSNumber numberWithInteger:fromIndex]};
    } else {
        parms = @{@"fromIndex": [NSNumber numberWithInteger:fromIndex]};
    }
    
    [[HttpPackage sharedInstance]
     httpRequestWithMethod:POST
     url:url
     parameters:parms
     success:success
     failure:failure
     timeout:timeout];
}

@end
