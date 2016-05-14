//
//  CredentialViewController.h
//  RBSClient
//
//  Created by Shengsheng on 14/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Venders.h"
#import "Models.h"

@interface CredentialViewController : UITableViewController <RecyclableViewController>

@property(strong, nonatomic) RoomBooking *roomBooking;

@end
