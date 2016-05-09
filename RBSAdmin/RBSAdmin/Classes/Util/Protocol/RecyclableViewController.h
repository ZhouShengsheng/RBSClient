//
//  RecyclableViewControllerProtocol.h
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Confirms this protocol to implement init and release methods so that the view of the
 *  view controller can be fully controlled.
 */
@protocol RecyclableViewController <NSObject>

@required

/**
 *  Initialize view of the view controller.
 *
 *  @see releaseView
 */
- (void)initializeView;

@optional

/**
 *  Release view of the view controller.
 *
 *  @see initializeView
 */
- (void)releaseView;

/**
 *  Get current UIScrollView.
 *  @return the visiable UIScrollView.
 */
- (UIScrollView *)currentScrollView;

/**
 *  Refresh views.
 */
- (void)reloadData;

@end
