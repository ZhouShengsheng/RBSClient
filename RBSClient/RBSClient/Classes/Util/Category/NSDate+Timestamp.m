//
//  NSDate+Timestamp.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "NSDate+Timestamp.h"

@implementation NSDate (Timestamp)

+ (NSString *)currentTimestamp {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", floor(timeStamp)];
}

@end
