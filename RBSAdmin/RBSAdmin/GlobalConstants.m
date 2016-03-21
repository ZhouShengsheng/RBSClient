//
//  GlobalConstants.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "GlobalConstants.h"
#import "DDLog.h"
#import <UIKit/UIKit.h>

@implementation GlobalConstants

+(instancetype) sharedInstance {
    static GlobalConstants *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

/**
 *  Init contants.
 */
- (void)commonInit {
    CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
    _screenWidth = CGRectGetWidth(mainScreenBounds);
    _screenHeight = CGRectGetHeight(mainScreenBounds);
    _statusHeight = 20.0f;
    _navigationBarHeight = 44.0f;
    _tabBarHeight = 49.0f;
    _margin = 8.0f;
}

- (NSString *)description {
    return [@{@"screenWidth": @(_screenWidth),
              @"screenHeight": @(_screenHeight),
              @"statusHeight": @(_statusHeight),
              @"navigationBarHeight": @(_navigationBarHeight),
              @"tabBarHeight": @(_tabBarHeight),
              @"margin": @(_margin)}
            description];
}

@end
