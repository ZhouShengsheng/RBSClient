//
//  DetailedBookingListViewController.h
//  RBSClient
//
//  Created by Shengsheng on 13/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Venders.h"
#import "Models.h"

/**
 *  Room booking list type enum.
 */
typedef NS_ENUM(NSUInteger, BookingType) {
    // For user.
    BOOKING_TYPE_PROCESSING,
    BOOKING_TYPE_APPROVED,
    BOOKING_TYPE_DECLINED,
    BOOKING_TYPE_HISTORY,
    // For admin.
    BOOKING_TYPE_ADMIN_PROCESSING,
    BOOKING_TYPE_ADMIN_PROCCESSED
};

@interface DetailedBookingListViewController : UITableViewController <RecyclableViewController>

/** Room booking type. */
@property(assign, nonatomic) BookingType bookingType;

/** Will auto load data. */
@property(assign, nonatomic) BOOL willAutoLoadData;

/** Parent navigation controller. */
@property(weak, nonatomic) UINavigationController *parentNavigationController;

@end
