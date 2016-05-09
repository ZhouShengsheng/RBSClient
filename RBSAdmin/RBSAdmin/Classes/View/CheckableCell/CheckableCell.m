//
//  CheckableCell.m
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "CheckableCell.h"

@implementation CheckableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.checkBox.animationDuration = 0.3f;
    self.checkBox.onTintColor = [UIColor themeColor];
    self.checkBox.onCheckColor = [UIColor themeColor];
    self.checkBox.onAnimationType = BEMAnimationTypeFlat;
    self.checkBox.offAnimationType = BEMAnimationTypeFlat;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
