//
//  BookingProgressCell.h
//  RBSClient
//
//  Created by Shengsheng on 12/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingProgressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *passOrFailImageView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

/**
 *  Display progress and icon related.
 */
- (void)displayProgress:(NSString *)progress;

/**
 *  Hide or show process image.
 */
- (void)setProcessImageHidden:(BOOL)hidden;

@end
