//
//  StudentBookingCell.m
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "StudentBookingCell.h"

@implementation StudentBookingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.roomLabel.textColor = [UIColor themeColor];
}

- (void)displayWithStudentBooking:(StudentBooking *)studentBooking {
    self.roomLabel.text = [studentBooking roomInfo];
    self.studentLabel.text = [studentBooking studentInfo];
    self.timeIntervalLabel.text = [studentBooking timeIntervalInfo];
}

@end
