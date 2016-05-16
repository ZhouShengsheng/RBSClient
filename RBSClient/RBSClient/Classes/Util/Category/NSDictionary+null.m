//
//  NSDictionary+null.m
//  iJuGou
//
//  Created by Hu Weizheng on 26/1/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import "NSDictionary+null.h"

@implementation NSDictionary (null)

- (id)nonNullObjectForKey:(id)key {
    id object;
    
    object = [self objectForKey:key];
    
    if (object == [NSNull null]) {
        return nil;
    }
    
    return object;
}

- (id)stringNonNullObjectForKey:(NSString *)key {
    id object;
    
    object = [self objectForKey:key];
    
    if (object == [NSNull null]) {
        return @"";
    }
    
    return object;
}

@end
