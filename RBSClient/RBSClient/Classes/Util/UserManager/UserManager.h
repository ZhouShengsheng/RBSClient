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

// User info.
@property(strong, readonly, nonatomic) id currentUser;
@property(copy, readonly, nonatomic) NSString *userId;
@property(copy, readonly, nonatomic) NSString *userIdDigest;
@property(copy, nonatomic) NSString *password;
@property(copy, readonly, nonatomic) NSString *userTypeStr;
@property(copy, readonly, nonatomic) NSString *userName;
@property(copy, readonly, nonatomic) NSArray *officeOrDorm;
@property(copy, readonly, nonatomic) NSArray *designationOrClass;
@property(copy, readonly, nonatomic) NSString *genderStr;
@property(copy, readonly, nonatomic) NSString *phone;

+ (instancetype)sharedInstance;

/**
 *  Auto login with completion.
 *  @param completion Completion block.
 */
- (void)autoLoginWithCompletion:(void (^)(BOOL succeed, NSString *message))completion;

/**
 *  Save user data.
 */
- (void)saveUserData;

/**
 *  Logout.
 */
- (void)logout;

@end
