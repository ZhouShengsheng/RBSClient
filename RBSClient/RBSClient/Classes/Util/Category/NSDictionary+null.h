//
//  NSDictionary+null.h
//  iJuGou
//
//  Created by Hu Weizheng on 26/1/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (null)

- (id)nonNullObjectForKey:(id)key;
- (id)stringNonNullObjectForKey:(NSString *)key;

@end
