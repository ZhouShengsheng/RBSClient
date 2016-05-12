//
//  StudentBookingCell.h
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"
#import "Venders.h"
#import "Utils.h"

@interface StudentBookingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalLabel;

- (void)displayWithStudentBooking:(StudentBooking *)studentBooking;

@end
