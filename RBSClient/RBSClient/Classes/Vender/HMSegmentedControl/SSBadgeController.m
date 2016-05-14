//
//  SSBadgeController.m
//  SSBadgeController
//
//  Created by Shengsheng on 7/3/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import "SSBadgeController.h"

@interface SSBadgeController ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) CATextLayer *textLayer;

@end

@implementation SSBadgeController

#pragma mark - Initializers

- (id)init {
    return [self initWithLayer:nil animated:YES];
}

- (instancetype)initWithLayer:(CALayer *)layer {
    return [self initWithLayer:layer animated:YES];
}

- (instancetype)initWithLayer:(CALayer *)layer animated:(BOOL)animated {
    if (self = [super init]) {
        _layer = layer;
        _animated = animated;
        self.badgeAnimationType = SSAnimationTypeZoomIn;
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit {
    _badgeBackgroundColor = [UIColor redColor];
    _badgeTextColor = [UIColor whiteColor];
    _badgeTextFont = [UIFont systemFontOfSize:12];
    _badgePositionAdjustment = UIOffsetZero;
    _animated = YES;
}

- (void)setBadgeAnimationType:(SSBadgeAnimationType)badgeAnimationType {
    _badgeAnimationType = badgeAnimationType;
    switch (_badgeAnimationType) {
        case SSAnimationTypeZoomIn: {
            _animationBlock = ^(CALayer *shapeLayer) {
                CABasicAnimation *animation =
                [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.fromValue = [NSValue
                                       valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1.0)];
                animation.toValue = [NSValue
                                     valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
                [animation setDuration:0.4];
                animation.fillMode = kCAFillModeForwards;
                [shapeLayer addAnimation:animation forKey:@"zoomIn"];
            };
            break;
        }
        case SSAnimationTypeBouncing: {
            _animationBlock = ^(CALayer *shapeLayer) {
                CABasicAnimation *animation1 =
                [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation1.fromValue = [NSValue
                                        valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1.0)];
                animation1.toValue = [NSValue
                                      valueWithCATransform3D:CATransform3DMakeScale(1.35, 1.35, 1.0)];
                [animation1 setDuration:0.32];
                animation1.fillMode = kCAFillModeForwards;
                
                CABasicAnimation *animation2 =
                [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation2.fromValue = [NSValue
                                        valueWithCATransform3D:CATransform3DMakeScale(1.35, 1.35, 1.0)];
                animation2.toValue = [NSValue
                                      valueWithCATransform3D:CATransform3DIdentity];
                [animation2 setDuration:0.18];
                [animation2 setBeginTime:0.32];
                animation2.fillMode = kCAFillModeForwards;
                
                CAAnimationGroup *group = [CAAnimationGroup animation];
                [group setDuration:0.5];
                [group setAnimations:[NSArray arrayWithObjects:animation1, animation2, nil]];
                [shapeLayer addAnimation:group forKey:@"bouncing"];
            };
            break;
        }
    }
}

#pragma mark - Setters

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    [self drawBadge];
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = badgeBackgroundColor;
    
    [self drawBadge];
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    _badgeTextColor = badgeTextColor;
    
    [self drawBadge];
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont {
    _badgeTextFont = badgeTextFont;
    
    [self drawBadge];
}

- (void)setBadgePositionAdjustment:(UIOffset)badgePositionAdjustment {
    _badgePositionAdjustment = badgePositionAdjustment;
    
    [self drawBadge];
}

- (void)setAnimated:(BOOL)animated {
    _animated = animated;
    
    [self drawBadge];
}

#pragma mark - Draw badge

- (void)drawBadge {
    CGSize frameSize = self.layer.frame.size;
    if ([[self badgeValue] length]) {
        CGSize badgeSize = CGSizeZero;
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: self.badgeTextFont}
                                                  context:nil].size;
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            badgeSize = [_badgeValue sizeWithFont:[self badgeTextFont]
                                constrainedToSize:CGSizeMake(frameSize.width, 20)];
#endif
        }
        
        CGFloat textOffset = 2.0f;
        
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        
        CGFloat backgroundSize = badgeSize.width + 2 * textOffset;
        CGRect badgeBackgroundFrame =
        CGRectMake(self.badgePositionAdjustment.horizontal + self.layer.frame.size.width,
                   textOffset + self.badgePositionAdjustment.vertical - backgroundSize/2.0,
                   backgroundSize,
                   badgeSize.height + 2 * textOffset);
        
        // Add background color.
        if (self.shapeLayer) {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
        }
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = badgeBackgroundFrame;
        self.shapeLayer.rasterizationScale = [UIScreen mainScreen].scale;
        self.shapeLayer.shouldRasterize = YES;
        self.shapeLayer.backgroundColor = [[self badgeBackgroundColor] CGColor];
        self.shapeLayer.cornerRadius = backgroundSize/2.0;
        
        // Add text.
        NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [badgeTextStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *badgeTextAttributes = @{
                                              NSFontAttributeName: self.badgeTextFont,
                                              NSForegroundColorAttributeName: self.badgeTextColor,
                                              NSParagraphStyleAttributeName: badgeTextStyle,
                                              };
        
        self.textLayer = [CATextLayer layer];
        self.textLayer.frame = CGRectMake(textOffset,
                                      textOffset,
                                      badgeSize.width, badgeSize.height);
        self.textLayer.alignmentMode = kCAAlignmentCenter;
        self.textLayer.truncationMode = kCATruncationEnd;
        self.textLayer.string = [[NSAttributedString alloc]
                                 initWithString:[self badgeValue] attributes:badgeTextAttributes];
        self.textLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.shapeLayer addSublayer:self.textLayer];
        
        // Add to layer.
        [self.layer addSublayer:self.shapeLayer];
        
        if (self.animated && self.animationBlock) {
            self.animationBlock(self.shapeLayer);
        }
    } else {
        if (self.shapeLayer) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.shapeLayer removeFromSuperlayer];
                self.shapeLayer = nil;
            });
//            [self.shapeLayer removeFromSuperlayer];
//            self.shapeLayer = nil;
        }
    }
}

@end
