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
 *  Login.
 */
- (void)loginWithType:(NSString *)type
               userId:(NSString *)userId
             password:(NSString *)password
              success:(void(^)(id jsonData))success
              failure:(void(^)(NSError *error))failure
              timeout:(void(^)(void))timeout;

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
                       capacity:(NSUInteger)capacity
                  hasMultiMedia:(NSNumber *)hasMultiMedia
                  timeIntervals:(NSString *)timeIntervals
                      fromIndex:(NSInteger)fromIndex
                        success:(void(^)(id jsonData))success
                        failure:(void(^)(NSError *error))failure
                        timeout:(void(^)(void))timeout;

@end
