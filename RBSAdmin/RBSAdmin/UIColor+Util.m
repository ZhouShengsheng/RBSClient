//
//  UIColor+Util.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

#pragma mark - Theme
+ (UIColor *)themeColor {
    return [UIColor colorWithRed:30/255.0
                           green:43/255.0
                            blue:85/255.0
                           alpha:1];
}

+ (UIColor *)alertColor {
    return [UIColor colorWithRed:0.976
                           green:0.306
                            blue:0.416
                           alpha:1];
}

+ (UIColor *)unselectedColor {
    return [UIColor colorWithRed:155/255.0
                           green:155/255.0
                            blue:155/255.0
                           alpha:1];
}

+ (UIColor *)buttonBgColor {
    return [UIColor colorWithRed:216/255.0
                           green:216/255.0
                            blue:216/255.0
                           alpha:1];
}

+ (UIColor *)bgColor {
    return [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
}

+ (UIColor *)labelTextColor {
    return [UIColor colorWithRed:74/255.0
                           green:74/255.0
                            blue:74/255.0
                           alpha:1];
}

+ (UIColor *)followBorderColor {
    return [UIColor colorWithRed:155/255.0
                           green:155/255.0
                            blue:155/255.0
                           alpha:1];
}

+ (UIColor *)segmentedControllDividerColor {
    return [UIColor colorWithRed:151/255.0
                           green:151/255.0
                            blue:151/255.0
                           alpha:1];
}


#pragma mark - theme colors

@end
