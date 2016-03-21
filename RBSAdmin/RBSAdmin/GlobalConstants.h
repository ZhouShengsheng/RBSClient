//
//  GlobalConstants.h
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GlobalConstants : NSObject

// sizes
@property (assign, nonatomic, readonly) CGFloat screenWidth;
@property (assign, nonatomic, readonly) CGFloat screenHeight;
@property (assign, nonatomic, readonly) CGFloat statusHeight;
@property (assign, nonatomic, readonly) CGFloat navigationBarHeight;
@property (assign, nonatomic, readonly) CGFloat tabBarHeight;
@property (assign, nonatomic, readonly) CGFloat margin;

+(instancetype) sharedInstance;

@end
