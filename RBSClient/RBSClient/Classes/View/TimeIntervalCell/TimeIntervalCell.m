//
//  TimeIntervalCell.m
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "TimeIntervalCell.h"

@implementation TimeIntervalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textLabel.font = [UIFont simpleDescriptionFont];
}

- (void)displayTimeInterval:(TimeInterval *)timeInterval {
    self.textLabel.text = [timeInterval description];
    // Alert the overlapped time interval.
    if (timeInterval.overlapped) {
        self.textLabel.textColor = [UIColor alertColor];
        self.textLabel.text = [NSString stringWithFormat:@"%@ [重叠]", [timeInterval description]];
    } else {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.text = [timeInterval description];
    }
}

@end
