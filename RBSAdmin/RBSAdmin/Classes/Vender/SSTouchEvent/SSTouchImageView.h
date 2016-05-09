//
//  SSTouchImageView.h
//  iJuGou
//
//  Created by Shengsheng on 14/3/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTouchEventController.h"

@interface SSTouchImageView : UIImageView

@property (strong, nonatomic) SSTouchEventController *touchEventController;

@end
