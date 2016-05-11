//
//  UserProfileCell.h
//  RBSClient
//
//  Created by Shengsheng on 11/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

- (void)displayKey:(NSString *)key value:(NSString *)value;
- (void)setEditEnable:(BOOL)enabled;
- (NSString *)value;
- (void)setSecureInput:(BOOL)secured;

@end
