//
//  SSPullController.h
//  Demo40_PullUpToShowMore
//
//  Created by Shengsheng on 9/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Pull state enum.
 */
typedef NS_ENUM(NSUInteger, PullState) {
    PULL_UP_TO_SHOW_MORE,
    RELEASE_TO_SHOW_MORE,
    PULL_DOWN_TO_RETURN,
    RELEASE_TO_RETURN
};

@interface SSPullController : NSObject

/**
 *  Content scroll view.
 */
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *infoView;

// Heights.
@property (assign, nonatomic) CGFloat topViewHeight;
@property (assign, nonatomic) CGFloat infoViewHeight;
@property (assign, nonatomic) CGFloat screenContainerHeight;
@property (assign, nonatomic) CGFloat triggerOffset;

@property (assign, nonatomic) PullState pullState;
@property (assign, nonatomic) BOOL animating;

@property (copy, nonatomic) void (^stateUpdateBlock)(SSPullController *pullController, PullState pullState);

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                     topViewHeight:(CGFloat)topViewHeight
                    infoViewHeight:(CGFloat)infoViewHeight
                     triggerOffset:(CGFloat)triggerOffset;
- (void)updateTriggerOffsets;

+ (NSString *)stringFromPullState:(PullState)pullState;

@end
