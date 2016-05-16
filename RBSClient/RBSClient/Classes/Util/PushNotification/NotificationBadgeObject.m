//
//  NotificationBadgeObject.m
//  Demo41_JTTree
//
//  Created by Shengsheng on 15/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "NotificationBadgeObject.h"

// NSCoding keys.
static NSString *const NSCodingNameKey = @"NSCodingNameKey";
static NSString *const NSCodingValueKey = @"NSCodingValueKey";

@implementation NotificationBadgeObject

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:NSCodingNameKey];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_value] forKey:NSCodingValueKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:NSCodingNameKey];
        _value = [[aDecoder decodeObjectForKey:NSCodingValueKey] unsignedIntegerValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@, %lu)",
            self.name,
            (unsigned long)self.value];
}

@end
