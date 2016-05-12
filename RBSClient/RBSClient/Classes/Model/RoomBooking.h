//
//  RoomBooking.h
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"
#import "Student.h"
#import "Faculty.h"

@interface RoomBooking : NSObject

// Info.
@property(copy, nonatomic) NSString *groupId;
@property(copy, nonatomic) NSString *roomBuilding;
@property(copy, nonatomic) NSString *roomNumber;
@property(copy, nonatomic) NSString *bookReason;
@property(copy, nonatomic) NSString *declineReason;
@property(strong, nonatomic) NSDate *creationTime;
@property(strong, nonatomic) NSMutableOrderedSet *timeIntervalList;
@property(assign, nonatomic) BOOL expired;
@property(copy, nonatomic) NSString *applicantType;
@property(copy, nonatomic) NSString *applicantId;
@property(copy, nonatomic) NSString *status;

@property(strong, nonatomic) Room *room;
@property(strong, nonatomic) Student *student;
@property(strong, nonatomic) Faculty *faculty;
@property(strong, nonatomic) Faculty *admin;

// Getters.
/** Progresses array. */
@property(copy, nonatomic) NSMutableArray *progresses;
@property(copy, nonatomic) NSString *roomInfo;
@property(copy, nonatomic) NSString *studentInfo;
@property(copy, nonatomic) NSString *adminInfo;
@property(copy, nonatomic) NSString *facultyInfo;
@property(copy, nonatomic) NSString *timeIntervalInfo;
@property(copy, nonatomic) NSString *creationTimeInfo;
@property(copy, nonatomic) NSString *applicantInfo;
@property(copy, nonatomic) NSString *supervisorInfo;

- (instancetype)initWithJsonData:(id)jsonData;

@end
