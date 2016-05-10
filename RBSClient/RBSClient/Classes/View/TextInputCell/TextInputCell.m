//
//  TextInputCell.m
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "TextInputCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.textView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
