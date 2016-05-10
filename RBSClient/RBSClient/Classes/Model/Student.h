//
//  Student.h
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Faculty.h"

@interface Student : NSObject <NSCoding>

@property (copy, nonatomic) NSString *studentId;
@property (copy, nonatomic) NSString *idDigest;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *className;
@property (assign, nonatomic) BOOL gender;
@property (copy, nonatomic) NSString *dormRoomNumber;
@property (copy, nonatomic) NSString *phone;

@property (strong, nonatomic) Faculty *supervisor;

- (instancetype)initWithJsonData:(id)jsonData;

@end
