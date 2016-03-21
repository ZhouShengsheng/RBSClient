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
                 timeout:(void(^)(void))timeout;

@end
