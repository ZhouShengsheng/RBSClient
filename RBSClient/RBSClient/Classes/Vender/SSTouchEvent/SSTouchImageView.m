//
//  SSTouchImageView.m
//  iJuGou
//
//  Created by Shengsheng on 14/3/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import "SSTouchImageView.h"

@implementation SSTouchImageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initTouchEventController];
    }
    return self;
}

- (void)awakeFromNib {
    [self initTouchEventController];
}

- (void)initTouchEventController {
    self.touchEventController = [[SSTouchEventController alloc] init];
    self.touchEventController.view = self;
}

#pragma mark - Touch events handling
//=========================================================================================
// Touch events handling
//=========================================================================================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.touchEventController touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.touchEventController touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.touchEventController touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.touchEventController touchesCancelled:touches withEvent:event];
}

@end
