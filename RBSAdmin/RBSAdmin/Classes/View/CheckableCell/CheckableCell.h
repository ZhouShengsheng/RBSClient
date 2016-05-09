//
//  CheckableCell.h
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venders.h"
#import "Utils.h"

@interface CheckableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;
@property (weak, nonatomic) IBOutlet BEMCheckBox *checkBox;

@end
