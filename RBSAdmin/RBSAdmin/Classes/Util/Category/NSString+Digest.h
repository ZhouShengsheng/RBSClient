//
//  NSString+MD5.h
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSHash/NSString+NSHash.h>
#import <NSHash/NSData+NSHash.h>

@interface NSString (Digest)

/**
 *  Generate a random 16 lengthed string.
 */
+ (NSString *)randomString;

/**
 *  Generate signature with userId, nonceStr and timestamp.
 */
+ (NSString *)signatureWithId:(NSString *)userId
                     nonceStr:(NSString *)nonceStr
                    timestamp:(NSString *)timestamp;

@end
