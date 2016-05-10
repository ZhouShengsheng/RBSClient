//
//  RoomBookingViewController.h
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venders.h"
#import "Utils.h"
#import "Models.h"

@interface RoomBookingViewController : UITableViewController <RecyclableViewController>

@property(strong, nonatomic) Room *room;

@end
