//
//  HttpPackage.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright (c) 2016 NTU. All rights reserved.
//

#import "HttpPackage.h"
#import "SimpleHttp.h"
#import "Utils.h"
#import "UserManager.h"

@implementation HttpPackage

+ (instancetype)sharedInstance {
    static HttpPackage *_singletonObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonObject = [[self alloc] init];
    });
    return _singletonObject;
}

- (NSDictionary *)prefixParameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [parameters mutableCopy];
    
    UserManager *userManager = [UserManager sharedInstance];
    params[@"idDigest"] = userManager.userIdDigest;
    NSString *nonceStr = [NSString randomString];
    NSString *timestamp = [NSDate currentTimestamp];
    params[@"nonceStr"] = nonceStr;
    params[@"timestamp"] = timestamp;
    params[@"signature"] = [NSString signatureWithId:[UserManager sharedInstance].userId
                                            nonceStr:nonceStr
                                           timestamp:timestamp];
    return params;
}

- (void)httpRequestWithMethod:(HttpMethod)method
                          url:(NSString*)url
                   parameters:(NSDictionary *)parameters
                      success:(void(^)(id jsonData))success
                      failure:(void(^)(NSError *error))failure
                      timeout:(void(^)(void))timeout {
    
    // Timer.
    __block BOOL isCancel = NO;
    NSTimer *httpRequestTimer = [NSTimer scheduledTimerWithTimeInterval:requestTimeout
                                                                 target:[NSBlockOperation blockOperationWithBlock:^{
        [httpRequestTimer invalidate];  // stop timer
        isCancel = YES; // cancel request
        if (timeout) timeout(); // otherwise, timeout block
    }] selector:@selector(main) userInfo:nil repeats:NO];
    
    // Prefix parameters.
    NSDictionary *params = [self prefixParameters:parameters];
    
    DDLogWarn(@"HTTP REQUEST: %@", @{@"url": url,
                                    @"parameters": params ? params : @""});
    
    // Competion handler.
    void (^competionHandler)(NSURLResponse*, NSData*, NSError*) =
    ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (httpRequestTimer.isValid) [httpRequestTimer invalidate];  // stop timer
        
        if (!isCancel) {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            if (!error) {
                id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                DDLogDebug(@"HTTP RESPONSE: %@", res);
                if (res) {
                    if(success) success(res); // send data to success block
                } else {
                    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if (string) {
                        //if(success) success(string); // send data to success block
                        NSError *strError = [NSError
                                             errorWithDomain:@"HttpPackage"
                                             code:1
                                             userInfo:@{@"message":
                                                            @"Response is string."}];
                        failure(strError);
                    }
                    else if (failure) failure(error); // any error to failure block
                }
            } else {
                if (failure) failure(error); // any error to failure block
                
                //                                if (![AppDelegate delegate].hasNetwork) {
                //                                    [[URLManager sharedInstance] setAvailableServer];
                //                                }
                
                NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                DDLogError(@"GET Error Code: %ld \n Error data: %@", (long)responseCode, errorString);
            }
        }
        else DDLogError(@"Get reuqest cancelled!");
    };
    
    // Send http request.
    switch (method) {
        case GET: {
            [SimpleHttp sendAsyncGetRequestToURL:url
                                  withParameters:params
                            andCompletionHandler:competionHandler];
            break;
        }
        case POST: {
            [SimpleHttp sendAsyncPostRequestToURL:url
                                   withParameters:params
                             andCompletionHandler:competionHandler];
            break;
        }
        case PUT: {
            [SimpleHttp sendAsyncPostRequestToURL:url
                                   withParameters:params
                             andCompletionHandler:competionHandler];
            break;
        }
        case PATCH: {
            [SimpleHttp sendAsyncPostRequestToURL:url
                                   withParameters:params
                             andCompletionHandler:competionHandler];
            break;
        }
        case DELETE: {
            [SimpleHttp sendAsyncPostRequestToURL:url
                                   withParameters:params
                             andCompletionHandler:competionHandler];
            break;
        }
    }
}

#pragma mark - HTTP Methods
//=========================================================================================
// HTTP Methods
//=========================================================================================
-(void)get:(NSString *)url
parameters:(NSDictionary *)parameters
   success:(void(^)(id jsonData))success
   failure:(void(^)(NSError *error))failure
   timeout:(void(^)(void))timeout {
    
    __block BOOL isCancel = NO;
    NSTimer *httpRequestTimer = [NSTimer scheduledTimerWithTimeInterval:requestTimeout
    target:[NSBlockOperation blockOperationWithBlock:^{
        [httpRequestTimer invalidate];  // stop timer
        isCancel = YES; // cancel request
        if (timeout) timeout(); // otherwise, timeout block
    }] selector:@selector(main) userInfo:nil repeats:NO];
    
    DDLogWarn(@"get REQUEST: %@", @{@"url": url,
                                         @"parameters": parameters ? parameters : @""});
    
    [SimpleHttp sendAsyncGetRequestToURL:url
                          withParameters:parameters
                    andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        
                        if (httpRequestTimer.isValid) [httpRequestTimer invalidate];  // stop timer
                        
                        if (!isCancel) {
                            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                            if (!error) {
                                id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                if (res) {
                                    if(success) success(res); // send data to success block
                                } else {
                                    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                    if (string) {
                                        //if(success) success(string); // send data to success block
                                        NSError *strError = [NSError
                                                             errorWithDomain:@"HttpPackage"
                                                             code:1
                                                             userInfo:@{@"message":
                                                                            @"Response is string."}];
                                        failure(strError);
                                    }
                                    else if (failure) failure(error); // any error to failure block
                                }
                            } else {
                                if (failure) failure(error); // any error to failure block
                                
//                                if (![AppDelegate delegate].hasNetwork) {
//                                    [[URLManager sharedInstance] setAvailableServer];
//                                }
                                
                                NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                
                                DDLogError(@"GET Error Code: %ld \n Error data: %@", (long)responseCode, errorString);
                            }
                        }
                        else DDLogError(@"Get reuqest cancelled!");
                    }];
}

-(void)post:(NSString *)url
 parameters:(NSDictionary *)parameters
    success:(void(^)(id jsonData))success
    failure:(void(^)(NSError *error))failure
    timeout:(void(^)(void))timeout {
    
    __block BOOL isCancel = NO;
    NSTimer *httpRequestTimer = [NSTimer scheduledTimerWithTimeInterval:requestTimeout
    target:[NSBlockOperation blockOperationWithBlock:^{
        [httpRequestTimer invalidate];  // stop timer
        isCancel = YES; // cancel request
        if (timeout) timeout(); // otherwise, timeout block
    }] selector:@selector(main) userInfo:nil repeats:NO];
    
    DDLogWarn(@"post REQUEST: %@", @{@"url": url,
                                          @"parameters": parameters ? parameters : @""});
    
    [SimpleHttp sendAsyncPostRequestToURL:url
                           withParameters:parameters
                     andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        
                         if (httpRequestTimer.isValid) [httpRequestTimer invalidate];  // stop timer
                         
                         if (!isCancel) {
                             NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                             
                             if (!error) {
                                 id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                 DDLogDebug(@"post RESPONSE: %@", res);
                                 
                                 if (res) {
                                     if(success) success(res); // send data to success block
                                 } else {
                                     NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                     if (string) {
                                         if(success) success(string); // send data to success block
                                     }
                                     else if (failure) failure(error); // any error to failure block
                                 }
                             } else {
                                 DDLogDebug(@"post error: %@", error);
                                 if (failure) failure(error); // any error to failure block
                                 
//                                 if (![AppDelegate delegate].hasNetwork) {
//                                     [[URLManager sharedInstance] setAvailableServer];
//                                 }

                                 NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                 
                                 DDLogError(@"POST Error Code: %ld \n Error data: %@", (long)responseCode, errorString);
                             }
                         }
                         else DDLogError(@"Post reuqest cancelled!");
                    }];
}

@end
