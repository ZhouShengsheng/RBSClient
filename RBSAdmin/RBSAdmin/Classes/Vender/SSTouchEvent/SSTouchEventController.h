//
//  SSTouchEventContoller.h
//  iJuGou
//
//  Created by Shengsheng on 14/3/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Touch effect type.
 */
typedef NS_ENUM(NSUInteger, SSTouchEffectType) {
    /**
     *  Background color will change when touch changes.
     */
    SSTouchEffectTypeBackgroundColor,
    /**
     *  Alpha will change when touch changes.
     *  In addition, alpha effect supports animation.
     */
    SSTouchEffectTypeAlpha
};

// default params
static const CGFloat SSTouchBorderOffset = 40.0f;
static const CGFloat SSBackgroundChangeDelay = 0.09f;
static const CGFloat SSAlphaAnimationDuration = 0.09f;

@interface SSTouchEventController : UIResponder

@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) SSTouchEffectType touchEffectType;
@property (assign, nonatomic) CGFloat touchBorderOffset;

// backgroundColor effect
@property (strong, nonatomic) UIColor *preBackgroundColor;
@property (strong, nonatomic) UIColor *touchedBackgroundColor;
@property (assign, nonatomic) CGFloat backgroundChangeDelay;

// alpha effect
@property (assign, nonatomic) CGFloat preAlpha;
@property (assign, nonatomic) CGFloat touchedAlpha;
@property (assign, nonatomic) BOOL willAnimateAlpha;
@property (assign, nonatomic) CGFloat alphaAnimationDuration;

/**
 *  Touch event block that will be executed when touch event ends.
 */
@property (copy, nonatomic) void (^touchEventBlock)(UIView *view);

#pragma mark - Easy event binders
- (void)setTouchEventWithPreBackgroundColor:(UIColor *)preBackgroundColor
                     touchedBackgroundColor:(UIColor *)touchedBackgroundColor
                            touchEventBlock:(void (^)(UIView *))touchEventBlock;

- (void)setTouchEventWithPreAlpha:(CGFloat)preAlpha
                     touchedAlpha:(CGFloat)touchedAlpha
                 willAnimateAlpha:(BOOL)willAnimateAlpha
                  touchEventBlock:(void (^)(UIView *))touchEventBlock;

@end
