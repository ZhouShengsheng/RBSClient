//
//  BookingListCell.h
//  RBSClient
//
//  Created by Shengsheng on 13/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomBooking.h"

@interface BookingListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalLabel;

- (void)displayWithRoomBooking:(RoomBooking *)roomBooking;

@end
