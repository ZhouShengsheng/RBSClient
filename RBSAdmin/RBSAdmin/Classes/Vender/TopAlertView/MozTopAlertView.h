//
//  MozTopAlertView.h
//  MoeLove
//
//  Created by LuLucius on 14/12/7.
//  Copyright (c) 2014年 MOZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MozAlertTypeInfo,
    MozAlertTypeSuccess,
    MozAlertTypeWarning,
    MozAlertTypeError
} MozAlertType;

@interface MozTopAlertView : UIView

@property(nonatomic, assign)BOOL autoHide;
@property(nonatomic, assign)NSInteger duration;

//@property(nonatomic, retain)UIView *viewController;

/*
 * btn target
 */
@property (nonatomic, copy) dispatch_block_t doBlock;

/*
 * action after dismiss
 */
@property (nonatomic, copy) dispatch_block_t dismissBlock;

+ (BOOL)hasViewWithParentView:(UIView*)viewController;
+ (void)hideViewWithParentView:(UIView*)viewController;
+ (MozTopAlertView*)viewWithParentView:(UIView*)viewController;

+ (MozTopAlertView*)showWithType:(MozAlertType)type text:(NSString*)text viewController:(UIView*)viewController;
+ (MozTopAlertView*)showWithType:(MozAlertType)type text:(NSString*)text doText:(NSString*)doText doBlock:(dispatch_block_t)doBlock viewController:(UIView*)viewController;

@end
