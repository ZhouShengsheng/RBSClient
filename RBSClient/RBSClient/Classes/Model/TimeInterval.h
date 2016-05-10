//
//  TimeInterval.h
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeInterval : NSObject

@property(strong, nonatomic) NSDate *from;
@property(strong, nonatomic) NSDate *to;

// Whether this time interval is overlapped.
@property(assign, nonatomic) BOOL overlapped;

/**
 *  Generate ordered set from json data.
 */
+ (NSMutableOrderedSet *)timeIntervalListFromJsonData:(id)jsonData;

/**
 *  Generate json string from time interval list.
 */
+ (NSString *)timeIntervalJsonStringFromOrderedSet:(NSOrderedSet *)timeIntervalList;

- (instancetype)initWithFrom:(NSDate *)from to:(NSDate *)to;

- (NSString *)date;
- (NSString *)fromTime;
- (NSString *)toTime;

/**
 *  Compare to another timeInterval.
 */
- (BOOL)isEqualToTimeInterval:(TimeInterval *)timeInterval;

@end
