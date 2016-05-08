//
//  AddTimeIntervalViewController.h
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"
#import "Utils.h"
#import "Venders.h"

@interface AddTimeIntervalViewController : UITableViewController <RecyclableViewController>

@property(assign, nonatomic) BOOL isEdit;
@property(strong, nonatomic) TimeInterval *timeInterval;

@end
