//
//  RoomInfoViewController.h
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venders.h"
#import "Utils.h"
#import "Models.h"

@interface RoomInfoViewController : UITableViewController <RecyclableViewController>

@property(copy, nonatomic) NSString *building;
@property(copy, nonatomic) NSString *number;

@end
