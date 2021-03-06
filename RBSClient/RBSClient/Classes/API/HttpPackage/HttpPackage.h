//
//  HttpPackage.h
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright (c) 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Request timeout in seconds.
 */
static const float requestTimeout = 8.0f;

typedef NS_ENUM(NSUInteger, HttpMethod) {
    GET,
    POST,
    PUT,
    PATCH,
    DELETE
};

/**
 *  Async http requests wrapper.
 */
@interface HttpPackage : NSObject

+ (instancetype)sharedInstance;

/**
 *  Send http request.
 */
- (void)httpRequestWithMethod:(HttpMethod)method
                          url:(NSString*)url
                   parameters:(NSDictionary *)parameters
                      success:(void(^)(id jsonData))success
                      failure:(void(^)(NSError *error))failure
                      timeout:(void(^)(void))timeout;

/**
 *  Get request.
 */
-(void)get:(NSString*)url
parameters:(NSDictionary *)parameters
   success:(void(^)(id jsonData))success
   failure:(void(^)(NSError *error))failure
   timeout:(void(^)(void))timeout;

/**
 *  Post request.
 */
-(void)post:(NSString*)url
 parameters:(NSDictionary *)parameters
    success:(void(^)(id jsonData))success
    failure:(void(^)(NSError *error))failure
    timeout:(void(^)(void))timeout;
@end
