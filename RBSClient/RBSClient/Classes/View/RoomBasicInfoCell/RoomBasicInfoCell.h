//
//  RoomBasicInfoCell.h
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"

@interface RoomBasicInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasMultiMediaLabel;

- (void)displayRoom:(Room *)room;

@end
