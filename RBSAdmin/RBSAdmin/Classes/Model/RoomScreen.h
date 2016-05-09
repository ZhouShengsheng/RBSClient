//
//  RoomScreen.h
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"

@interface RoomScreen : NSObject <NSCopying>

// Screen conditions.
@property(strong, nonatomic) NSMutableOrderedSet *buildingList;
@property(assign, nonatomic) NSUInteger capacity;
@property(strong, nonatomic) NSMutableOrderedSet *hasMultiMediaList;
@property(strong, nonatomic) NSMutableOrderedSet *timeIntervalList;

// Time interval just added.
@property(strong, nonatomic) TimeInterval *addedTimeInterval;

// Time interval to be edited.
@property(strong, nonatomic) TimeInterval *editedTimeInterval;

+ (instancetype)sharedInstance;
+ (void)updateSharedInstance:(RoomScreen *)roomScreen;

@end
