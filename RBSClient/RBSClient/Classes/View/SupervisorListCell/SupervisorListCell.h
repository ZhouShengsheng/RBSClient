//
//  SupervisorListCell.h
//  RBSClient
//
//  Created by Shengsheng on 11/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"
#import "Utils.h"

@interface SupervisorListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designationLabel;

- (void)displayWithFaculty:(Faculty *)faculty;

@end
