//
//  UserProfileCell.m
//  RBSClient
//
//  Created by Shengsheng on 11/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "UserProfileCell.h"

@implementation UserProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayKey:(NSString *)key value:(NSString *)value {
    self.keyLabel.text = key;
    self.valueTextField.text = value;
}

- (void)setEditEnable:(BOOL)enabled {
    self.valueTextField.enabled = enabled;
}

- (NSString *)value {
    return self.valueTextField.text;
}

- (void)setSecureInput:(BOOL)secured {
    if (secured) {
        self.valueTextField.secureTextEntry = YES;
    } else {
        self.valueTextField.secureTextEntry = NO;
    }
}

@end
