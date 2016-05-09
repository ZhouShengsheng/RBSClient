//
//  Faculty.h
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Faculty : NSObject <NSCoding>

@property (copy, nonatomic) NSString *facultyId;
@property (copy, nonatomic) NSString *idDigest;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *designation;
@property (assign, nonatomic) BOOL gender;
@property (copy, nonatomic) NSString *office;
@property (copy, nonatomic) NSString *phone;

@end
