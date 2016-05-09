//
//  UserManager.h
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Faculty.h"
#import "Student.h"

/**
 *  User type enum.
 */
typedef NS_ENUM(NSUInteger, UserType) {
    USER_TYPE_UNKNOWN,
    USER_TYPE_ADMIN,
    USER_TYPE_FACULTY,
    USER_TYPE_STUDENT
};

@interface UserManager : NSObject

// User.
@property(assign, nonatomic) UserType userType;
@property(strong, nonatomic) Faculty *admin;
@property(strong, nonatomic) Faculty *faculty;
@property(strong, nonatomic) Student *student;

+ (instancetype)sharedInstance;

/**
 *  Auto login with completion.
 *  @param completion Completion block.
 */
- (void)autoLoginWithCompletion:(void (^)(BOOL succeed, NSString *message))completion;

/**
 *  Save user data.
 */
-(void)saveUserData;

/**
 *  Get user id.
 */
- (NSString *)userId;

/**
 *  Get user id digest.
 */
- (NSString *)userIdDigest;

/**
 *  Get user type as string.
 */
- (NSString *)userTypeStr;

@end
