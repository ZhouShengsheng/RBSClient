//
//  NSString+MD5.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "NSString+Digest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Digest)

static const NSString *randomLetters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+ (NSString *)randomStringWithLength:(int) len{
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [randomLetters characterAtIndex: arc4random_uniform([randomLetters length])]];
    }
    
    return randomString;
}

+ (NSString *)randomString {
    return [self randomStringWithLength:16];
}

+ (NSString *)signatureWithId:(NSString *)userId
                     nonceStr:(NSString *)nonceStr
                    timestamp:(NSString *)timestamp {
    NSString *str = [NSString stringWithFormat:@"id=%@&nonceStr=%@&timestamp=%@",
                        userId, nonceStr, timestamp];
    return [str SHA1];
}

@end
