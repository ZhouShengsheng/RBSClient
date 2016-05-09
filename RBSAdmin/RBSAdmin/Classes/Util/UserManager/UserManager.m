//
//  UserManager.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "UserManager.h"
#import "Utils.h"
#import "APIManager.h"

#define kUserInfo @"USER_INFO"

@implementation UserManager

+ (instancetype)sharedInstance {
    static UserManager *_singletonObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonObject = [[self alloc] init];
    });
    return _singletonObject;
}

- (instancetype)init {
    if (self = [super init]) {
        self.userType = USER_TYPE_UNKNOWN;
    }
    return self;
}

-(void)saveUserData {
    AppTools *appTools = [AppTools sharedInstance];
    switch (self.userType) {
        case USER_TYPE_UNKNOWN: {
            break;
        }
        case USER_TYPE_ADMIN: {
            NSData *adminData = [NSKeyedArchiver archivedDataWithRootObject:self.admin];
            [appTools writeToUserDefaultsWithObject:adminData forKey:@"admin"];
            break;
        }
        case USER_TYPE_FACULTY: {
            NSData *facultyData = [NSKeyedArchiver archivedDataWithRootObject:self.faculty];
            [appTools writeToUserDefaultsWithObject:facultyData forKey:@"faculty"];
            break;
        }
        case USER_TYPE_STUDENT: {
            NSData *studentData = [NSKeyedArchiver archivedDataWithRootObject:self.student];
            [appTools writeToUserDefaultsWithObject:studentData forKey:@"student"];
            break;
        }
    }
    [appTools writeToUserDefaultsWithObject:[NSNumber numberWithUnsignedInteger:self.userType]
                                     forKey:@"userType"];
}

/**
 *  Load user data.
 *  @param completion
 *      Completion block.
 */
- (void)loadUserData {
    DDLogError(@"Loading user data...");
    AppTools *appTools = [AppTools sharedInstance];
    NSNumber *userType = [appTools objectFromUserDefaultsForKey:@"userType"];
    if (!userType) {
        return ;
    }
    self.userType = [userType unsignedIntegerValue];
    switch (self.userType) {
        case USER_TYPE_UNKNOWN: {
            break;
        }
        case USER_TYPE_ADMIN: {
            NSData *adminData = [appTools objectFromUserDefaultsForKey:@"admin"];
            self.admin = [NSKeyedUnarchiver unarchiveObjectWithData:adminData];
            break;
        }
        case USER_TYPE_FACULTY: {
            NSData *facultyData = [appTools objectFromUserDefaultsForKey:@"faculty"];
            self.faculty = [NSKeyedUnarchiver unarchiveObjectWithData:facultyData];
            break;
        }
        case USER_TYPE_STUDENT: {
            NSData *studentData = [appTools objectFromUserDefaultsForKey:@"student"];
            self.student = [NSKeyedUnarchiver unarchiveObjectWithData:studentData];
            break;
        }
    }
}

- (void)autoLoginWithCompletion:(void (^)(BOOL succeed, NSString *message))completion {
    DDLogError(@"Auto login...");
    [self loadUserData];
    if (self.userType == USER_TYPE_UNKNOWN) {
        // 初始用户。
        if (completion) {
            completion(NO, @"初始用户。");
        }
    } else {
        NSString *type;
        NSString *userId;
        NSString *password;
        switch (self.userType) {
            case USER_TYPE_UNKNOWN: {
                type = @"unknown";
                userId = @"";
                password = @"";
                break;
            }
            case USER_TYPE_ADMIN: {
                type = @"admin";
                userId = self.admin.facultyId;
                password = self.admin.password;
                break;
            }
            case USER_TYPE_FACULTY: {
                type = @"faculty";
                userId = self.faculty.facultyId;
                password = self.faculty.password;
                break;
            }
            case USER_TYPE_STUDENT: {
                type = @"student";
                userId = self.student.studentId;
                password = self.student.password;
                break;
            }
        }
        
        // Send login request.
        [[APIManager sharedInstance]
         loginWithType:type
         userId:userId
         password:password
         success:^(id jsonData) {
             NSString *message = jsonData[@"message"];
             if (!message) {
                 if (completion) {
                     completion(YES, nil);
                 }
             } else {
                 DDLogError(@"Login message: %@", message);
                 completion(NO, @"登录失败！学工号或密码错误！");
             }
         }
         failure:^(NSError *error) {
             completion(NO, @"服务器错误，请重新登录！");
         }
         timeout:^{
             completion(NO, @"登陆超时！");
         }];
    }
}

- (NSString *)userId {
    switch (self.userType) {
        case USER_TYPE_UNKNOWN: {
            return nil;
        }
        case USER_TYPE_ADMIN: {
            return self.admin.facultyId;
        }
        case USER_TYPE_FACULTY: {
            return self.faculty.facultyId;
        }
        case USER_TYPE_STUDENT: {
            return self.student.studentId;
        }
    }
}

- (NSString *)userIdDigest {
    switch (self.userType) {
        case USER_TYPE_UNKNOWN: {
            return nil;
        }
        case USER_TYPE_ADMIN: {
            return self.admin.idDigest;
        }
        case USER_TYPE_FACULTY: {
            return self.faculty.idDigest;
        }
        case USER_TYPE_STUDENT: {
            return self.student.idDigest;
        }
    }
}

- (NSString *)userTypeStr {
    switch (self.userType) {
        case USER_TYPE_UNKNOWN: {
            return @"unknown";
        }
        case USER_TYPE_ADMIN: {
            return @"admin";
        }
        case USER_TYPE_FACULTY: {
            return @"faculty";
        }
        case USER_TYPE_STUDENT: {
            return @"student";
        }
    }
}

@end
