//
//  URLManager.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "URLManager.h"

@implementation URLManager

+ (instancetype)sharedInstance {
    static URLManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        [instance initUrls];
    });
    return instance;
}

- (NSString *)formUrlWithRoute:(NSString *)route {
    return [NSString stringWithFormat:@"%@:%u%@",
            server, port, route];
}

- (void)initUrls {
    _adminLoginURL = [self formUrlWithRoute:@"/user/admin_login"];
}

@end
