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
 *  Admin login.
 */
- (void)adminLoginWithId:(NSString *)adminId
                password:(NSString *)password
                 success:(void(^)(id jsonData))success
                 failure:(void(^)(NSError *error))failure
                 timeout:(void(^)(void))timeout {
    NSString *url = [URLManager sharedInstance].adminLoginURL;
    
    NSDictionary *parms =
    @{@"id": adminId,
      @"password": [password MD5String]};
    
    [[HttpPackage sharedInstance]
     post:url
     parameters:parms
     success:success
     failure:failure
     timeout:timeout];
}

@end
