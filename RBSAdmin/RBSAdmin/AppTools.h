//
//  AppTools.h
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTools : NSObject

+ (instancetype)sharedInstance;

/**
 *  Load data from userDefault.
 */
- (id)objectFromUserDefaultsForKey:(NSString *)key;

/**
 *  Write data data userDefault.
 */
- (void)writeToUserDefaultsWithObject:(id)object forKey:(NSString *)key;

@end
