//
//  RoomListCell.h
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"
#import "Venders.h"
#import "Utils.h"

@interface RoomListCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *buildingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (void)displayWithRoom:(Room *)room;

@end
