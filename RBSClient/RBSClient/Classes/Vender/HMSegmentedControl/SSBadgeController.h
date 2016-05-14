//
//  SSBadgeController.h
//  SSBadgeController
//
//  Created by Shengsheng on 7/3/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Badge animation type.
 */
typedef NS_ENUM(NSUInteger, SSBadgeAnimationType) {
    /**
     *  Zoom in from disappear to appear.
     */
    SSAnimationTypeZoomIn,
    /**
     *  Bouncing effect.
     */
    SSAnimationTypeBouncing,
};

@interface SSBadgeController : NSObject

#pragma mark - CALayer
/**
 *  The layer to add badge on.
 */
@property (strong, nonatomic) CALayer *layer;

#pragma mark - Badge configuration

/**
 *  Text that is displayed in the upper-right corner of the item with a surrounding background.
 */
@property (copy, nonatomic) NSString *badgeValue;

/**
 *  Color used for badge's background.
 */
@property (strong, nonatomic) UIColor *badgeBackgroundColor;

/**
 *  Color used for badge's text.
 */
@property (strong, nonatomic) UIColor *badgeTextColor;

/**
 *  The offset for the rectangle around the tab bar item's badge.
 */
@property (assign, nonatomic) UIOffset badgePositionAdjustment;

/**
 *  Font used for badge's text.
 */
@property (strong, nonatomic) UIFont *badgeTextFont;

/**
 *  Will animate the appearing.
 */
@property (assign, nonatomic) BOOL animated;

/**
 *  Badge animation type.
 *  Default is SSAnimationTypeZoomIn.
 */
@property (assign, nonatomic) SSBadgeAnimationType badgeAnimationType;

/**
 *  Animation block.
 */
@property (copy, nonatomic) void (^animationBlock)(CALayer *shapeLayer);

#pragma mark - Badge operations

- (instancetype)initWithLayer:(CALayer *)layer;
- (instancetype)initWithLayer:(CALayer *)layer animated:(BOOL)animated;

/**
 *  Default init.
 */
- (void)defaultInit;

/**
 *  Draw badge.
 */
- (void)drawBadge;

@end
