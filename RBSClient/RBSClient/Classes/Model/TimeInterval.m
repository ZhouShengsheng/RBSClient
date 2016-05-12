//
//  TimeInterval.m
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "TimeInterval.h"
#import "Utils.h"

@interface TimeInterval ()

@property(strong, nonatomic) NSDateFormatter *dateFormat;
@property(strong, nonatomic) NSDateFormatter *timeFormat;

@end

@implementation TimeInterval

- (void)commonInit {
    self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.timeFormat = [[NSDateFormatter alloc] init];
    [self.timeFormat setDateFormat:@"HH:mm"];
}

- (instancetype)init {
    return [self initWithFrom:nil to:nil];
}

- (instancetype)initWithFrom:(NSDate *)from to:(NSDate *)to {
    if (self = [super init]) {
        [self commonInit];
        self.from = from;
        self.to = to;
    }
    return self;
}

+ (NSMutableOrderedSet *)timeIntervalListFromJsonData:(id)jsonData {
    NSMutableOrderedSet *timeIntervalList = [NSMutableOrderedSet orderedSet];
    NSArray *jsonArray = (NSArray *)jsonData;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];

    for (NSArray *timeInterval in jsonArray) {
        NSDate *from = [dateFormatter
                        dateFromString:[timeInterval[0] substringWithRange: NSMakeRange(0, 16)]];
        NSDate *to = [dateFormatter
                      dateFromString:[timeInterval[1] substringWithRange: NSMakeRange(0, 16)]];
        TimeInterval *interval = [[TimeInterval alloc]
                                  initWithFrom:from
                                  to:to];
        [timeIntervalList addObject:interval];
    }
    
    return timeIntervalList;
}

+ (NSMutableOrderedSet *)timeIntervalListFromJsonString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *jsonArray = (NSArray *)jsonData;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    
    NSMutableOrderedSet *timeIntervalList = [NSMutableOrderedSet orderedSet];
    for (NSArray *timeIntervalStringArray in jsonArray) {
        NSString *timeIntervalString = timeIntervalStringArray.firstObject;
        NSDate *from = [dateFormatter
                        dateFromString:[timeIntervalString substringWithRange: NSMakeRange(0, 16)]];
        NSDate *to = [dateFormatter
                      dateFromString:[timeIntervalString substringWithRange: NSMakeRange(20, 16)]];
        TimeInterval *interval = [[TimeInterval alloc]
                                  initWithFrom:from
                                  to:to];
        [timeIntervalList addObject:interval];
    }
    //DDLogError(@"timeIntervalList: %@", timeIntervalList);
    return timeIntervalList;
}

+ (NSString *)timeIntervalJsonStringFromOrderedSet:(NSOrderedSet *)timeIntervalList {
    NSMutableArray *timeIntervalStrList = [NSMutableArray array];
    for (TimeInterval *timeInterval in timeIntervalList) {
        NSString *from = [NSString stringWithFormat:@"%@ %@:00",
                          [timeInterval date], [timeInterval fromTime]];
        NSString *to = [NSString stringWithFormat:@"%@ %@:00",
                        [timeInterval date], [timeInterval toTime]];
        NSArray *fromTo = @[from, to];
        [timeIntervalStrList addObject:fromTo];
    }
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:timeIntervalStrList
                        options:NSJSONWritingPrettyPrinted
                        error:nil];
    NSString *timeIntervals = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    timeIntervals = [timeIntervals stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return timeIntervals;
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

- (BOOL)isEqualToTimeInterval:(TimeInterval *)timeInterval {
    //DDLogError(@"%@ == %@", self, timeInterval);
    return [[self description] isEqualToString:[timeInterval description]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@-%@", [self date], [self fromTime], [self toTime]];
}

@end
