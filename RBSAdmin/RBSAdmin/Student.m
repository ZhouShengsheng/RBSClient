//
//  Student.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "Student.h"

@implementation Student

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.studentId forKey:@"studentId"];
    [aCoder encodeObject:self.idDigest forKey:@"idDigest"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.className forKey:@"className"];
    [aCoder encodeObject:[NSNumber numberWithBool:_gender] forKey:@"gender"];
    [aCoder encodeObject:self.dormRoomNumber forKey:@"dormRoomNumber"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.studentId = [aDecoder decodeObjectForKey:@"studentId"];
        self.idDigest = [aDecoder decodeObjectForKey:@"idDigest"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.className = [aDecoder decodeObjectForKey:@"className"];
        self.gender = [[aDecoder decodeObjectForKey:@"gender"] boolValue];
        self.dormRoomNumber = [aDecoder decodeObjectForKey:@"dormRoomNumber"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
    }
    return self;
}

@end
