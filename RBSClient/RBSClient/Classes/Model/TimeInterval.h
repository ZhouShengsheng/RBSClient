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

- (NSString *)date;
- (NSString *)fromTime;
- (NSString *)toTime;

@end
