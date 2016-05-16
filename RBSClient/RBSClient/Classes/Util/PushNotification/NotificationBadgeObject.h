//
//  NotificationBadgeObject.h
//  Demo41_JTTree
//
//  Created by Shengsheng on 15/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationBadgeObject : NSObject <NSCoding>

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger value;

- (instancetype)initWithName:(NSString *)name;

@end
