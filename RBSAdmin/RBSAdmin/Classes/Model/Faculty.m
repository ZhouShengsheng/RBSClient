//
//  Faculty.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "Faculty.h"

@implementation Faculty

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.facultyId forKey:@"facultyId"];
    [aCoder encodeObject:self.idDigest forKey:@"idDigest"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.designation forKey:@"designation"];
    [aCoder encodeObject:[NSNumber numberWithBool:_gender] forKey:@"gender"];
    [aCoder encodeObject:self.office forKey:@"office"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.facultyId = [aDecoder decodeObjectForKey:@"facultyId"];
        self.idDigest = [aDecoder decodeObjectForKey:@"idDigest"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.designation = [aDecoder decodeObjectForKey:@"designation"];
        self.gender = [[aDecoder decodeObjectForKey:@"gender"] boolValue];
        self.office = [aDecoder decodeObjectForKey:@"office"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
    }
    return self;
}

@end
