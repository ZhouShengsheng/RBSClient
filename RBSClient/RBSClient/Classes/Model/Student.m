//
//  Student.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "Student.h"

@implementation Student

- (instancetype)initWithJsonData:(id)jsonData {
    if (self = [super init]) {
        self.studentId = jsonData[@"id"];
        self.idDigest = jsonData[@"idDigest"];
        self.name = jsonData[@"name"];
        self.gender = [jsonData[@"gender"] boolValue];
        self.className = jsonData[@"classname"];
        self.dormRoomNumber = jsonData[@"dormroomnumber"];
        self.phone = jsonData[@"phone"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.studentId forKey:@"studentId"];
    [aCoder encodeObject:self.idDigest forKey:@"idDigest"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.className forKey:@"className"];
    [aCoder encodeObject:[NSNumber numberWithBool:_gender] forKey:@"gender"];
    [aCoder encodeObject:self.dormRoomNumber forKey:@"dormRoomNumber"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    
    NSData *supervisorData = [NSKeyedArchiver archivedDataWithRootObject:self.supervisor];
    [aCoder encodeObject:supervisorData forKey:@"supervisor"];
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
        
        NSData *supervisorData = [aDecoder decodeObjectForKey:@"supervisor"];
        self.supervisor = [NSKeyedUnarchiver unarchiveObjectWithData:supervisorData];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@",
            self.name, @"学生", self.studentId];
}

@end
