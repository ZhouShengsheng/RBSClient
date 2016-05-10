//
//  TimeIntervalCell.h
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Models.h"
#import "Venders.h"

@interface TimeIntervalCell : SWTableViewCell

- (void)displayTimeInterval:(TimeInterval *)timeInterval;

@end
