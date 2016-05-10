//
//  SimpleDescriptionCell.m
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "SimpleDescriptionCell.h"
#import "Utils.h"

@implementation SimpleDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textLabel.font = [UIFont simpleDescriptionFont];
}

- (void)displayDescription:(id)object {
    self.textLabel.text = [object description];
}

@end
