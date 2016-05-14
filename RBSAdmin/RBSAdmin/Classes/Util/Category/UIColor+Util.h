//
//  UIColor+Util.h
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

/**
 *  Label text color, RGBA(249, 78, 106, 255).
 */
+ (UIColor *)themeColor;

/**
 *  RGBA(249, 78, 106, 255).
 */
+ (UIColor *)alertColor;

/**
 *  RGBA(249, 78, 106, 255).
 */
+ (UIColor *)warningColor;

/**
 *  RGBA(155, 155, 155, 100).
 */
+ (UIColor *)unselectedColor;

/**
 *  Background color for button.
 */
+ (UIColor *)buttonBgColor;

+ (UIColor *)bgColor;

/**
 *  Label text color, RGBA(74, 74, 74, 255).
 */
+ (UIColor *)labelTextColor;

/**
 *  Label text color, RGBA(155, 155, 155, 100).
 */
+ (UIColor *)followBorderColor;

/**
 *  Segmented control vertical divider color, RGBA(151, 151, 151, 100).
 */
+ (UIColor *)segmentedControllDividerColor;

@end