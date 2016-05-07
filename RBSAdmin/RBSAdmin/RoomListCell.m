//
//  RoomListCell.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomListCell.h"
#import "Utils.h"

@implementation RoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buildingNumberLabel.textColor = [UIColor themeColor];
}

@end
