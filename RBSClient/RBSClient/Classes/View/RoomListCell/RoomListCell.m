//
//  RoomListCell.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomListCell.h"

@implementation RoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buildingNumberLabel.textColor = [UIColor themeColor];
}

- (void)displayWithRoom:(Room *)room {
    self.buildingNumberLabel.text = [room.building stringByAppendingString:room.number];
    self.infoLabel.text = [NSString stringWithFormat:@"%lu人 %@多媒体设备",
                           (unsigned long)room.capacity, room.hasMultiMedia ? @"有": @"无"];
}

@end
