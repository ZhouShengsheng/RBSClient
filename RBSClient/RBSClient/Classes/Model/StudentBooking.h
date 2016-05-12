//
//  StudentBooking.h
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentBooking : NSObject

// Info.
@property(copy, nonatomic) NSString *groupId;
@property(copy, nonatomic) NSString *roomBuilding;
@property(copy, nonatomic) NSString *roomNumber;
@property(copy, nonatomic) NSString *bookReason;
@property(copy, nonatomic) NSString *adminId;
@property(copy, nonatomic) NSString *facultyId;
@property(copy, nonatomic) NSString *declineReason;
@property(strong, nonatomic) NSDate *creationTime;
@property(copy, nonatomic) NSString *studentId;
@property(copy, nonatomic) NSString *studentName;
@property(copy, nonatomic) NSString *studentClassname;
@property(assign, nonatomic) BOOL studentGender;
@property(copy, nonatomic) NSString *studentDormRoomNumber;
@property(copy, nonatomic) NSString *studentPhone;
@property(strong, nonatomic) NSMutableOrderedSet *timeIntervalList;

// Getters.
@property(copy, nonatomic) NSString *roomInfo;
@property(copy, nonatomic) NSString *studentInfo;
@property(copy, nonatomic) NSString *timeIntervalInfo;

- (instancetype)initWithJsonData:(id)jsonData;


@end
