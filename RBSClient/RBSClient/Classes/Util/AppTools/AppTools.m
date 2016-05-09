//
//  AppTools.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "AppTools.h"

@interface AppTools ()

@property(strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation AppTools

+ (instancetype)sharedInstance {
    static AppTools *_singletonObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonObject = [[self alloc] init];
    });
    return _singletonObject;
}

- (instancetype)init {
    if (self = [super init]) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (id)objectFromUserDefaultsForKey:(NSString*)key {
    return [self.defaults objectForKey:key];
}

- (void)writeToUserDefaultsWithObject:(id)object forKey:(NSString *)key {
    [self.defaults setObject:object forKey:key];
    [self.defaults synchronize];
}

@end
