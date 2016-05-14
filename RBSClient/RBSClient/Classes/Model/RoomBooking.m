//
//  RoomBooking.m
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomBooking.h"
#import "TimeInterval.h"

@interface RoomBooking ()

@property(strong, nonatomic) NSDateFormatter *dateFormat;
@property(strong, nonatomic) NSDateFormatter *timeFormat;

@end

@implementation RoomBooking

- (void)commonInit {
    self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.timeFormat = [[NSDateFormatter alloc] init];
    [self.timeFormat setDateFormat:@"HH:mm"];
}

- (instancetype)initWithJsonData:(id)jsonData {
    if (self = [super init]) {
        [self commonInit];
        // Basic info.
        self.groupId = jsonData[@"groupid"];
        self.roomBuilding = jsonData[@"roombuilding"];
        self.roomNumber = jsonData[@"roomnumber"];
        self.timeIntervalList = [TimeInterval timeIntervalListFromJsonString:jsonData[@"timeintervals"]];
        self.bookReason = jsonData[@"bookreason"];
        self.expired = [jsonData[@"expired"] boolValue];
        self.declineReason = jsonData[@"declinereason"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
        self.creationTime = [dateFormatter
                        dateFromString:[jsonData[@"creationtime"] substringWithRange: NSMakeRange(0, 16)]];
        self.applicantType = jsonData[@"applicanttype"];
        self.applicantId = jsonData[@"applicantid"];
        self.status = jsonData[@"status"];
        
        // Room.
        self.room = [Room new];
        self.room.building = jsonData[@"building"];
        self.room.number = jsonData[@"number"];
        self.room.capacity = [jsonData[@"capacity"] unsignedIntegerValue];
        self.room.hasMultiMedia = [jsonData[@"hasmultimedia"] boolValue];
        
        // Faculty.
        self.faculty = [Faculty new];
        self.faculty.facultyId = jsonData[@"facultyid"];
        self.faculty.name = jsonData[@"facultyname"];
        self.faculty.designation = jsonData[@"facultydesignation"];
        self.faculty.gender = [jsonData[@"facultygender"] boolValue];
        self.faculty.office = jsonData[@"facultyoffice"];
        self.faculty.phone = jsonData[@"facultyphone"];
        self.faculty.facultyId = jsonData[@"facultyid"];
        
        // Admin.
        self.admin = [Faculty new];
        self.admin.facultyId = jsonData[@"adminid"];
        self.admin.name = jsonData[@"adminname"];
        self.admin.designation = jsonData[@"admindesignation"];
        self.admin.gender = [jsonData[@"admingender"] boolValue];
        self.admin.office = jsonData[@"adminoffice"];
        self.admin.phone = jsonData[@"adminphone"];
        
        // Student.
        if ([self.applicantType isEqualToString:@"student"]) {
            self.student = [Student new];
            self.student.studentId = self.applicantId;
            self.student.name = jsonData[@"studentname"];
            self.student.className = jsonData[@"studentclassname"];
            self.student.gender = [jsonData[@"studentgender"] boolValue];
            self.student.dormRoomNumber = jsonData[@"studentdormroomnumber"];
            self.student.phone = jsonData[@"studentphone"];
        }
        
    }
    return self;
}

- (NSMutableArray *)progresses {
    NSMutableArray *progs = [NSMutableArray array];
    if ([self.status isEqualToString:@"canceled"]) {
        [progs addObject:@"用户已取消"];
    } else {
        if (!self.expired) {
            if ([self.status isEqualToString:@"created"]) {
                [progs addObject:@"创建申请"];
                [progs addObject:@"上级审核中"];
            } else if ([self.status isEqualToString:@"faculty_approved"]) {
                [progs addObject:@"创建申请"];
                [progs addObject:@"上级审核通过"];
                [progs addObject:@"管理员审核中"];
            } else if ([self.status isEqualToString:@"faculty_declined"]) {
                [progs addObject:@"创建申请"];
                [progs addObject:@"上级已拒绝"];
                [progs addObject:@"审核不通过"];
            } else if ([self.status isEqualToString:@"admin_approved"]) {
                [progs addObject:@"创建申请"];
                [progs addObject:@"上级审核通过"];
                [progs addObject:@"管理员审核通过"];
                [progs addObject:@"审核通过"];
            } else if ([self.status isEqualToString:@"admin_declined"]) {
                [progs addObject:@"创建申请"];
                [progs addObject:@"上级审核通过"];
                [progs addObject:@"管理员已拒绝"];
                [progs addObject:@"审核不通过"];
            }
        } else {
            [progs addObject:@"申请已过期"];
        }
    }
    
    return progs;
}

- (NSString *)roomInfo {
    return [self.room description];
}

- (NSString *)studentInfo {
    return [self.student description];
}

- (NSString *)adminInfo {
    return [self.admin description];
}

- (NSString *)facultyInfo {
    return [self.faculty description];
}

- (NSString *)timeIntervalInfo {
    return [NSString stringWithFormat:@"%@ %@",
            [self.timeIntervalList.firstObject description],
            self.timeIntervalList.count > 1 ? @"..." : @""];
}

- (NSString *)creationTimeInfo {
    return [NSString stringWithFormat:@"%@ %@",
            [self.dateFormat stringFromDate:self.creationTime],
            [self.timeFormat stringFromDate:self.creationTime]];
}

- (NSString *)applicantInfo {
    if ([self.applicantType isEqualToString:@"student"]) {
        return self.student.description;
    } else {
        return self.faculty.description;
    }
}

- (NSString *)supervisorInfo {
    if ([self.applicantType isEqualToString:@"student"]) {
        return self.faculty.description;
    } else {
        return @"无";
    }
}

@end
