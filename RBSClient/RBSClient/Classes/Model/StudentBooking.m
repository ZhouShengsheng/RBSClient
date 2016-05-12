//
//  StudentBooking.m
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "StudentBooking.h"
#import "TimeInterval.h"
#import "Utils.h"

@implementation StudentBooking

- (instancetype)initWithJsonData:(id)jsonData {
    if (self = [super init]) {
        self.groupId = jsonData[@"groupid"];
        self.roomBuilding = jsonData[@"roombuilding"];
        self.roomNumber = jsonData[@"roomnumber"];
        self.timeIntervalList = [TimeInterval timeIntervalListFromJsonString:jsonData[@"timeintervals"]];
        self.bookReason = jsonData[@"bookreason"];
        self.adminId = jsonData[@"adminid"];
        self.facultyId = jsonData[@"facultyid"];
        self.declineReason = jsonData[@"declinereason"];
        self.creationTime = jsonData[@"creationtime"];
        self.studentId = jsonData[@"studentid"];
        self.studentName = jsonData[@"studentname"];
        self.studentClassname = jsonData[@"studentclassname"];
        self.studentGender = [jsonData[@"studentgender"] boolValue];
        self.studentDormRoomNumber = jsonData[@"studentdormroomnumber"];
        self.studentPhone = jsonData[@"studentphone"];
    }
    return self;
}

- (NSString *)roomInfo {
    return [NSString stringWithFormat:@"%@%@", self.roomBuilding, self.roomNumber];
}

- (NSString *)studentInfo {
    return [NSString stringWithFormat:@"%@ %@", self.studentName, self.studentId];
}

- (NSString *)timeIntervalInfo {
    return [NSString stringWithFormat:@"%@ %@",
            [self.timeIntervalList.firstObject description],
            self.timeIntervalList.count > 1 ? @"...": @""];
}

@end
