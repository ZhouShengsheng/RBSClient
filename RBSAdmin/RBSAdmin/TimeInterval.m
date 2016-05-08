//
//  TimeInterval.m
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "TimeInterval.h"

@interface TimeInterval ()

@property(strong, nonatomic) NSDateFormatter *dateFormat;
@property(strong, nonatomic) NSDateFormatter *timeFormat;

@end

@implementation TimeInterval

- (instancetype)init {
    if (self = [super init]) {
        self.dateFormat = [[NSDateFormatter alloc] init];
        [self.dateFormat setDateFormat:@"yyyy-MM-dd"];
        self.timeFormat = [[NSDateFormatter alloc] init];
        [self.timeFormat setDateFormat:@"HH:mm"];
    }
    return self;
}

- (NSString *)date {
    return [self.dateFormat stringFromDate:self.from];
}

- (NSString *)fromTime {
    return [self.timeFormat stringFromDate:self.from];
}

- (NSString *)toTime {
    return [self.timeFormat stringFromDate:self.to];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@-%@", [self date], [self fromTime], [self toTime]];
}

@end
