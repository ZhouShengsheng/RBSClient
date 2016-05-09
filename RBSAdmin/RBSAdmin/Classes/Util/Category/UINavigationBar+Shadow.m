//
//  UINavigationBar+Shadow.m
//  iJuGou
//
//  Created by Shengsheng on 24/2/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import "UINavigationBar+Shadow.h"

@implementation UINavigationBar (Shadow)

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [self applyDefaultStyle];
}

- (void)applyDefaultStyle {
    // add the drop shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2.0);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
}

@end
