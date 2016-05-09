//
//  SSTouchEventContoller.m
//  iJuGou
//
//  Created by Shengsheng on 14/3/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import "SSTouchEventController.h"

@interface SSTouchEventController ()

@property (assign, nonatomic) BOOL touched;

@end

@implementation SSTouchEventController

#pragma mark - Easy event binders
//=========================================================================================
// Easy event binders
//=========================================================================================
- (void)setTouchEventWithPreBackgroundColor:(UIColor *)preBackgroundColor
                     touchedBackgroundColor:(UIColor *)touchedBackgroundColor
                            touchEventBlock:(void (^)(UIView *))touchEventBlock {
    self.view.userInteractionEnabled = YES;

    self.touchEffectType = SSTouchEffectTypeBackgroundColor;
    self.preBackgroundColor = preBackgroundColor;
    if (!touchedBackgroundColor) {
        self.touchedBackgroundColor = [UIColor colorWithRed:191.0/255
                                                      green:191.0/255
                                                       blue:191.0/255
                                                      alpha:100.0/155];
    } else {
        self.touchedBackgroundColor = touchedBackgroundColor;
    }
    self.touchEventBlock = touchEventBlock;
    self.touchBorderOffset = SSTouchBorderOffset;
    self.backgroundChangeDelay = SSBackgroundChangeDelay;
}

- (void)setTouchEventWithPreAlpha:(CGFloat)preAlpha
                     touchedAlpha:(CGFloat)touchedAlpha
                 willAnimateAlpha:(BOOL)willAnimateAlpha
                  touchEventBlock:(void (^)(UIView *))touchEventBlock{
    self.view.userInteractionEnabled = YES;
    self.touchEffectType = SSTouchEffectTypeAlpha;
    self.preAlpha = preAlpha;
    self.touchedAlpha = touchedAlpha;
    self.willAnimateAlpha = willAnimateAlpha;
    self.touchEventBlock = touchEventBlock;
    self.touchBorderOffset = SSTouchBorderOffset;
    self.alphaAnimationDuration = SSAlphaAnimationDuration;
}

#pragma mark - Touch events handling
//=========================================================================================
// Touch events handling
//=========================================================================================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchEventBlock) {
        self.touched = YES;
        switch (self.touchEffectType) {
            case SSTouchEffectTypeBackgroundColor: {
                // change background color afater a short delay
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.backgroundChangeDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //self.preBackgroundColor = self.backgroundColor;
                    self.view.backgroundColor = self.touchedBackgroundColor;
                    // if user just tapped the view, change the backgroundColor back
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.backgroundChangeDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!self.touched) {
                            self.view.backgroundColor = self.preBackgroundColor;
                        }
                    });
                });
                break;
            }
            case SSTouchEffectTypeAlpha: {
                if (self.willAnimateAlpha) {
                    [UIView animateWithDuration:self.alphaAnimationDuration
                                     animations:^{
                                         self.view.alpha = self.touchedAlpha;
                                     }
                                     completion:^(BOOL finished) {

                                     }];
                } else {
                    self.view.alpha = self.touchedAlpha;
                }
                break;
            }
        }

        //[self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        //[super touchesBegan:touches withEvent:event];
        //[self.nextResponder touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchEventBlock) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        CGRect rect = CGRectInset(self.view.bounds, -self.touchBorderOffset, -self.touchBorderOffset);
        // check if user moves out of the view
        if (!CGRectContainsPoint(rect, touchLocation)) {
            self.touched = NO;

            switch (self.touchEffectType) {
                case SSTouchEffectTypeBackgroundColor: {
                    self.view.backgroundColor = self.preBackgroundColor;
                    break;
                }
                case SSTouchEffectTypeAlpha: {
                    if (self.willAnimateAlpha) {
                        [UIView animateWithDuration:self.alphaAnimationDuration
                                         animations:^{
                                             self.view.alpha = self.preAlpha;
                                         }
                                         completion:^(BOOL finished) {

                                         }];
                    } else {
                        self.view.alpha = self.preAlpha;
                    }
                    break;
                }
            }
        } else {
            self.touched = YES;

            switch (self.touchEffectType) {
                case SSTouchEffectTypeBackgroundColor: {
                    self.view.backgroundColor = self.touchedBackgroundColor;
                    break;
                }
                case SSTouchEffectTypeAlpha: {
                    if (self.willAnimateAlpha) {
                        [UIView animateWithDuration:self.alphaAnimationDuration
                                         animations:^{
                                             self.view.alpha = self.touchedAlpha;
                                         }
                                         completion:^(BOOL finished) {

                                         }];
                    } else {
                        self.view.alpha = self.touchedAlpha;
                    }
                    break;
                }
            }
        }

        //[self.nextResponder touchesMoved:touches withEvent:event];
    } else {
        //[self.nextResponder touchesMoved:touches withEvent:event];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchEventBlock) {
        if (self.touched) {
            self.touched = NO;

            switch (self.touchEffectType) {
                case SSTouchEffectTypeBackgroundColor: {
                    self.view.backgroundColor = self.preBackgroundColor;
                    break;
                }
                case SSTouchEffectTypeAlpha: {
                    if (self.willAnimateAlpha) {
                        [UIView animateWithDuration:self.alphaAnimationDuration
                                         animations:^{
                                             self.view.alpha = self.preAlpha;
                                         }
                                         completion:^(BOOL finished) {

                                         }];
                    } else {
                        self.view.alpha = self.preAlpha;
                    }
                    break;
                }
            }
            self.touchEventBlock(self.view);
        }

        //[self.nextResponder touchesMoved:touches withEvent:event];
    } else {

        //[self.nextResponder touchesMoved:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touched) {
        self.touched = NO;

        switch (self.touchEffectType) {
            case SSTouchEffectTypeBackgroundColor: {
                self.view.backgroundColor = self.preBackgroundColor;
                break;
            }
            case SSTouchEffectTypeAlpha: {
                if (self.willAnimateAlpha) {
                    [UIView animateWithDuration:self.alphaAnimationDuration
                                     animations:^{
                                         self.view.alpha = self.preAlpha;
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }];
                } else {
                    self.view.alpha = self.preAlpha;
                }
                break;
            }
        }
    }
    if (self.touchEventBlock) {
        //[self.nextResponder touchesCancelled:touches withEvent:event];
    } else {
        
        //[self.nextResponder touchesCancelled:touches withEvent:event];
    }
}

@end
