//
//  NSObject+NSNull.m
//  iJuGou
//
//  Created by Hu Weizheng on 23/12/15.
//  Copyright © 2015 CAP_NTU. All rights reserved.
//

#import "NSNull+json.h"
#import "DDLog.h"

@implementation NSNull (json)

- (id)objectForKey:(id)aKey
{
    DDLogInfo(@"found objectForKey <null>");
    return nil;
}

- (id)objectAtIndex:(NSUInteger)index
{
    DDLogInfo(@"found objectAtIndex <null>");
    return nil;
}

- (NSUInteger)length
{
    DDLogInfo(@"found length <null>");
    return 0;
}

- (float)floatValue
{
    DDLogInfo(@"found float <null>");
    return 0;
}

- (double)doubleValue
{
    DDLogInfo(@"found double <null>");
    return 0;
}

- (BOOL)boolValue
{
    DDLogInfo(@"found BOOL <null>");
    return 0;
}

- (NSInteger)integerValue NS_AVAILABLE(10_5, 2_0)
{
    DDLogInfo(@"found NSInteger <null>");
    return 0;
}

- (NSString *)stringValue
{
    DDLogInfo(@"found NSString <null>");
    return @"";
}

- (BOOL)isEqualToNumber:(NSNumber *)number
{
    DDLogInfo(@"found isEqualToNumber <null>");
    return 0;
}

- (BOOL)isEqualToString:(NSString *)data
{
    DDLogInfo(@"found isEqualToString <null>");
    return 0;
}

@end
