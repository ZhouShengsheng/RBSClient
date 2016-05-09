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

@end
