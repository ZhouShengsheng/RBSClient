//
//  BookingListCell.m
//  RBSClient
//
//  Created by Shengsheng on 13/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "BookingListCell.h"

@implementation BookingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayWithRoomBooking:(RoomBooking *)roomBooking {
    self.roomLabel.text = [NSString stringWithFormat:@"%@%@",
                           roomBooking.roomBuilding, roomBooking.roomNumber];
    self.progressLabel.text = roomBooking.progresses.lastObject;
    self.timeIntervalLabel.text = roomBooking.timeIntervalInfo;
}

@end
