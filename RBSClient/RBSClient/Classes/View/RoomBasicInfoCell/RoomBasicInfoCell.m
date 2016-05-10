//
//  RoomBasicInfoCell.m
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomBasicInfoCell.h"

@implementation RoomBasicInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buildingLabel.text = @"--";
    self.numberLabel.text = @"--";
    self.capacityLabel.text = @"--";
    self.hasMultiMediaLabel.text = @"--";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayRoom:(Room *)room {
    self.buildingLabel.text = room.building;
    self.numberLabel.text = room.number;
    self.capacityLabel.text = [@(room.capacity) stringValue];
    self.hasMultiMediaLabel.text = room.hasMultiMedia ? @"有": @"无";
}

@end
