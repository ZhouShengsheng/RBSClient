//
//  SSPullController.m
//  Demo40_PullUpToShowMore
//
//  Created by Shengsheng on 9/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "SSPullController.h"

#define SCREEN_HEIGHT   CGRectGetHeight([UIScreen mainScreen].bounds)

static const CGFloat SSAnimationDuration = 0.25;

@interface SSPullController () <UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat topTriggerOffset;
@property (assign, nonatomic) CGFloat bottomTriggerOffset;
@property (assign, nonatomic) PullState prePullState;

@end

@implementation SSPullController

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                     topViewHeight:(CGFloat)topViewHeight
                    infoViewHeight:(CGFloat)infoViewHeight
                     triggerOffset:(CGFloat)triggerOffset {
    if (self = [super init]) {
        _scrollView = scrollView;
        _topViewHeight = topViewHeight;
        _infoViewHeight = infoViewHeight;
        _triggerOffset = triggerOffset;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _prePullState = -1;
    _pullState = PULL_UP_TO_SHOW_MORE;
    _screenContainerHeight = SCREEN_HEIGHT;
    [self updateTriggerOffsets];
    
    self.infoView = [[UILabel alloc]
                     initWithFrame:CGRectMake(0,
                                              self.topViewHeight,
                                              CGRectGetWidth(self.scrollView.bounds),
                                              self.infoViewHeight)];
    self.infoView.textColor = [UIColor blackColor];
    self.infoView.font = [UIFont systemFontOfSize:16];
    self.infoView.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.infoView];
    
    self.scrollView.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"self.scrollView.contentSize.height: %.0f", self.scrollView.contentSize.height);
        UIEdgeInsets edgeInsets = {0, 0, self.topViewHeight - self.scrollView.contentSize.height, 0};
        self.scrollView.contentInset = edgeInsets;
    });
}

- (void)setInfoView:(UILabel *)infoView {
    [self.infoView removeFromSuperview];
    _infoView = infoView;
    [self updateTriggerOffsets];
}

- (void)updateTriggerOffsets {
    self.topTriggerOffset = self.topViewHeight -
        CGRectGetHeight(self.scrollView.frame) + self.triggerOffset;
    self.bottomTriggerOffset = self.topViewHeight + self.infoViewHeight - self.triggerOffset;
}

- (void)setStateUpdateBlock:(void (^)(SSPullController *, PullState))stateUpdateBlock {
    _stateUpdateBlock = stateUpdateBlock;
    [self checkStateUpdateBlock];
}

- (void)checkStateUpdateBlock {
    if (self.prePullState == self.pullState) {
        return ;
    }
    self.prePullState = self.pullState;
    if (self.stateUpdateBlock) {
        self.stateUpdateBlock(self, self.pullState);
    }
}

+ (NSString *)stringFromPullState:(PullState)pullState {
    switch (pullState) {
        case PULL_UP_TO_SHOW_MORE: {
            return @"PULL_UP_TO_SHOW_MORE";
        }
        case RELEASE_TO_SHOW_MORE: {
            return @"RELEASE_TO_SHOW_MORE";
        }
        case PULL_DOWN_TO_RETURN: {
            return @"PULL_DOWN_TO_RETURN";
        }
        case RELEASE_TO_RETURN: {
            return @"RELEASE_TO_RETURN";
        }
    }
}

- (void)checkState {
    if (self.animating) {
        return ;
    }
    
    switch (self.pullState) {
        case PULL_UP_TO_SHOW_MORE: {
            if (self.scrollView.contentOffset.y >= self.topTriggerOffset) {
                //self.infoView.text = self.releaseToShowMoreString;
                self.pullState = RELEASE_TO_SHOW_MORE;
                [self checkStateUpdateBlock];
            } else {
                //self.infoView.text = self.pullUpToShowMoreString;
                [self checkStateUpdateBlock];
            }
            break;
        }
        case RELEASE_TO_SHOW_MORE: {
            if (self.scrollView.contentOffset.y >= self.topTriggerOffset) {
                if (self.scrollView.isDragging) {
                    //self.infoView.text = self.releaseToShowMoreString;
                    [self checkStateUpdateBlock];
                } else {
                    //self.infoView.text = self.pullUpToShowMoreString;
                    self.pullState = PULL_UP_TO_SHOW_MORE;
                    [self checkStateUpdateBlock];
                }
                
            } else if (self.scrollView.contentOffset.y < self.topTriggerOffset) {
                //self.infoView.text = self.pullUpToShowMoreString;
                self.pullState = PULL_UP_TO_SHOW_MORE;
                [self checkStateUpdateBlock];
            }
            break;
        }
        case PULL_DOWN_TO_RETURN: {
            if (self.scrollView.contentOffset.y <= self.bottomTriggerOffset) {
                //self.infoView.text = self.releaseToReturnString;
                self.pullState = RELEASE_TO_RETURN;
                [self checkStateUpdateBlock];
            } else {
                //self.infoView.text = self.pullDownToReturnString;
                [self checkStateUpdateBlock];
            }
            break;
        }
        case RELEASE_TO_RETURN: {
            if (self.scrollView.contentOffset.y <= self.bottomTriggerOffset) {
                if (self.scrollView.isDragging) {
                    //self.infoView.text = self.releaseToReturnString;
                    [self checkStateUpdateBlock];
                } else {
                    //self.infoView.text = self.pullDownToReturnString;
                    self.pullState = PULL_DOWN_TO_RETURN;
                    [self checkStateUpdateBlock];
                }
                
            } else if (self.scrollView.contentOffset.y > self.bottomTriggerOffset) {
                //self.infoView.text = self.pullDownToReturnString;
                self.pullState = PULL_DOWN_TO_RETURN;
                [self checkStateUpdateBlock];
            }
            break;
        }
    }
}

- (void)checkSwitch {
    switch (self.pullState) {
        case PULL_UP_TO_SHOW_MORE: {
            break;
        }
        case RELEASE_TO_SHOW_MORE: {
            if (self.scrollView.contentOffset.y >= self.topTriggerOffset) {
                self.animating = YES;
                [UIView animateWithDuration:SSAnimationDuration
                                 animations:^{
                                     UIEdgeInsets edgeInsets =
                                     {-(self.topViewHeight + self.infoViewHeight), 0, 1, 0};
                                     self.scrollView.contentInset = edgeInsets;
                                 }
                                 completion:^(BOOL finished) {
                                     self.animating = NO;
                                     //self.infoView.text = self.pullDownToReturnString;
                                     self.pullState = PULL_DOWN_TO_RETURN;
                                     [self checkStateUpdateBlock];
                                 }];
                
            } else if (self.scrollView.contentOffset.y < self.topTriggerOffset) {
                //self.infoView.text = self.pullUpToShowMoreString;
                self.pullState = PULL_UP_TO_SHOW_MORE;
                [self checkStateUpdateBlock];
            }
            break;
        }
        case PULL_DOWN_TO_RETURN: {
            break;
        }
        case RELEASE_TO_RETURN: {
            if (self.scrollView.contentOffset.y <= self.bottomTriggerOffset) {
                self.animating = YES;
                [UIView animateWithDuration:SSAnimationDuration
                                 animations:^{
                                     UIEdgeInsets edgeInsets = {0, 0, self.topViewHeight - self.scrollView.contentSize.height, 0};
                                     self.scrollView.contentInset = edgeInsets;
                                 }
                                 completion:^(BOOL finished) {
                                     self.animating = NO;
                                     //self.infoView.text = self.pullUpToShowMoreString;
                                     self.pullState = PULL_UP_TO_SHOW_MORE;
                                     [self checkStateUpdateBlock];
                                 }];
                
            } else if (self.scrollView.contentOffset.y > self.bottomTriggerOffset) {
                //self.infoView.text = self.pullUpToShowMoreString;
                self.pullState = PULL_DOWN_TO_RETURN;
                [self checkStateUpdateBlock];
            }
            break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"y: %.0f", scrollView.contentOffset.y);
    //NSLog(@"top offset trigger: %.0f", self.topTriggerOffset);
    [self checkState];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self checkSwitch];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.pullState == RELEASE_TO_SHOW_MORE &&
        !scrollView.isDragging) {
        // stop fling
        [scrollView setContentOffset:scrollView.contentOffset animated:YES];
    } else if (self.pullState == RELEASE_TO_RETURN &&
               !scrollView.isDragging) {
        [scrollView setContentOffset:scrollView.contentOffset animated:YES];
    }
}

@end
