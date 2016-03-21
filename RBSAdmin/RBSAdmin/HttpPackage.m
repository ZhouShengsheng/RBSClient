//
//  HttpPackage.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright (c) 2016 NTU. All rights reserved.
//

#import "HttpPackage.h"
#import "SimpleHttp.h"
#import "DDLog.h"

@implementation HttpPackage

+ (instancetype)sharedInstance {
    static HttpPackage *_singletonObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonObject = [[self alloc] init];
    });
    return _singletonObject;
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
                                
                                NSLog(@"GET Error Code: %ld \n Error data: %@", (long)responseCode, errorString);
                            }
                        }
                        else NSLog(@"Get reuqest cancelled!");
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
                                 
                                 NSLog(@"POST Error Code: %ld \n Error data: %@", (long)responseCode, errorString);
                             }
                         }
                         else DDLogError(@"Post reuqest cancelled!");
                    }];
}

@end
