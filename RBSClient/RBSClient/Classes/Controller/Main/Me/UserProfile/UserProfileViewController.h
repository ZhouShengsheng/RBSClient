//
//  UserProfileViewController.h
//  RBSClient
//
//  Created by Shengsheng on 11/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venders.h"
#import "Utils.h"
#import "Models.h"

@interface UserProfileViewController : UITableViewController <RecyclableViewController>

// View faculty info.
@property(strong, nonatomic) Faculty *faculty;

@end
