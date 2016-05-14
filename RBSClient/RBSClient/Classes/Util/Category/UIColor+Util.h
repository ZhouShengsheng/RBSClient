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
 *  Theme color.
 */
+ (UIColor *)themeColor;

/**
 *  Alert color.
 */
+ (UIColor *)alertColor;

/**
 *  Warning color.
 */
+ (UIColor *)warningColor;

/**
 *  Tab bar unselected color.
 */
+ (UIColor *)unselectedColor;

/**
 *  Background color for button.
 */
+ (UIColor *)buttonBgColor;

/**
 *  Label text color.
 */
+ (UIColor *)labelTextColor;

/**
 *  Segmented control vertical divider color.
 */
+ (UIColor *)segmentedControllDividerColor;

@end