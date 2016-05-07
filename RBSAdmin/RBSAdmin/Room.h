//
//  Room.h
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property (copy, nonatomic) NSString *building;
@property (copy, nonatomic) NSString *number;
@property (assign, nonatomic) NSUInteger capacity;
@property (assign, nonatomic) BOOL hasMultiMedia;

@end
