//
//  Room.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "Room.h"

@implementation Room

- (instancetype)initWithJsonData:(id)jsonData {
    if (self = [super init]) {
        self.building = jsonData[@"building"];
        self.number = jsonData[@"number"];
        self.capacity = [jsonData[@"capacity"] unsignedIntegerValue];
        self.hasMultiMedia = [jsonData[@"hasmultimedia"] unsignedIntegerValue];
    }
    return self;
}

@end
