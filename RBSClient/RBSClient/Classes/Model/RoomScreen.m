//
//  RoomScreen.m
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomScreen.h"

@implementation RoomScreen

static RoomScreen *_singletonObject = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonObject = [[self alloc] init];
    });
    return _singletonObject;
}

+ (void)updateSharedInstance:(RoomScreen *)roomScreen {
    _singletonObject = [roomScreen copy];
}

- (instancetype)init {
    if (self = [super init]) {
        self.buildingList = [NSMutableOrderedSet orderedSet];
        [self.buildingList addObject:@"软件楼"];
        [self.buildingList addObject:@"图书馆"];
        self.capacity = 0;
        self.hasMultiMediaList = [NSMutableOrderedSet orderedSet];
        [self.hasMultiMediaList addObject:@"有"];
        [self.hasMultiMediaList addObject:@"无"];
        self.timeIntervalList = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    RoomScreen *copy = [[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        copy.buildingList = [[self.buildingList copyWithZone:zone] mutableCopy];
        copy.hasMultiMediaList = [[self.hasMultiMediaList copyWithZone:zone] mutableCopy];
        copy.timeIntervalList = [[self.timeIntervalList copyWithZone:zone] mutableCopy];
        
        // Set primitives
        copy.capacity = self.capacity;
    }
    
    return copy;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"楼栋: %@\n容量: %lu\n多媒体: %@\n空闲时间段: %@\n",
            self.buildingList, (unsigned long)self.capacity, self.hasMultiMediaList, self.timeIntervalList];
}

@end
