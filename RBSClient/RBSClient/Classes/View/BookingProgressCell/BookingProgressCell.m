//
//  BookingProgressCell.m
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "BookingProgressCell.h"
#import "Utils.h"

@implementation BookingProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)displayProgress:(NSString *)progress {
    self.progressLabel.text = progress;
    
    if ([progress isEqualToString:@"申请已过期"] ||
        [progress containsString:@"拒绝"]) {
        self.progressLabel.textColor = [UIColor warningColor];
    } else if ([progress isEqualToString:@"审核不通过"]) {
        self.passOrFailImageView.image = [UIImage imageNamed:@"icon_failed"];
        self.progressLabel.textColor = [UIColor alertColor];
    } else {
        self.passOrFailImageView.image = [UIImage imageNamed:@"icon_passed"];
        if ([progress isEqualToString:@"审核通过"]) {
            self.progressLabel.textColor = [UIColor colorWithHexString:@"B8E986"];
        } else {
            self.progressLabel.textColor = [UIColor blackColor];
        }
    }
}

- (void)setProcessImageHidden:(BOOL)hidden {
    self.passOrFailImageView.hidden = hidden;
}

@end
