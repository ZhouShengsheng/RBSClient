//
//  SupervisorListCell.m
//  RBSClient
//
//  Created by Shengsheng on 11/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "SupervisorListCell.h"

@implementation SupervisorListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor = [UIColor themeColor];
}

- (void)displayWithFaculty:(Faculty *)faculty {
    self.nameLabel.text = faculty.name;
    self.designationLabel.text = faculty.designation;
}

@end
