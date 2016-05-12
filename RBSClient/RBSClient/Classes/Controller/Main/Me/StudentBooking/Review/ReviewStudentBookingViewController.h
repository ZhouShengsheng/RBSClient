//
//  ReviewStudentBookingViewController.h
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venders.h"
#import "Utils.h"
#import "Models.h"

@interface ReviewStudentBookingViewController : UITableViewController <RecyclableViewController>

/** Group id of this booking. */
@property(copy, nonatomic) NSString *studentBookingGroupId;

@end
