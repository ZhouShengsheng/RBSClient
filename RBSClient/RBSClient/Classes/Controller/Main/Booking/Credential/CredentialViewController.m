//
//  CredentialViewController.m
//  RBSClient
//
//  Created by Shengsheng on 14/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "CredentialViewController.h"
#import "SimpleDescriptionCell.h"
#import "TextInputCell.h"
#import "TimeIntervalCell.h"
#import "BookingProgressCell.h"
#import "APIManager.h"
#import "UserManager.h"
#import "DeclineViewController.h"
#import "RoomBookingViewController.h"

@interface CredentialViewController ()

@end

@implementation CredentialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    // Title.
    self.title = @"电子凭证";
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleDescriptionCell" bundle:nil]
         forCellReuseIdentifier:@"SimpleDescriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeIntervalCell" bundle:nil]
         forCellReuseIdentifier:@"TimeIntervalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookingProgressCell" bundle:nil]
         forCellReuseIdentifier:@"BookingProgressCell"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self addCredentialImageView];
    
//    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc]
//                                         initWithTitle:@"保存图片"
//                                         style:UIBarButtonItemStylePlain
//                                         target:self
//                                         action:@selector(export)];
//    self.navigationItem.rightBarButtonItem = exportButton;
}

/**
 *  Add credential image view as table footer view.
 */
- (void)addCredentialImageView {
    GlobalConstants *consts = [GlobalConstants sharedInstance];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithImage:[UIImage imageNamed:@"image_approved_credential"]];
    imageView.top = 8;
    imageView.left = roundf((consts.screenWidth - imageView.width)/2.0f);
    
    UIView *view = [[UIView alloc] init];
    view.width = consts.screenWidth;
    view.height = imageView.height + 16;
    
    [view addSubview:imageView];
    self.tableView.tableFooterView = view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.roomBooking) {
        return 0;
    }
    
    // 教室信息
    // 申请人信息
    // 申请事由
    // 申请时间段
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        // 教室信息
        case 0: {
            return @"教室信息";
        }
        // 申请人信息
        case 1: {
            return @"申请人信息";
        }
        // 申请事由
        case 2: {
            return @"申请事由";
        }
        // 申请时间段
        case 3: {
            return @"申请时间段";
        }
        
        default: {
            return nil;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        // 教室信息
        case 0: {
            return 1;
        }
        // 申请人信息
        case 1: {
            return 1;
        }
        // 申请事由
        case 2: {
            return 1;
        }
        // 申请时间段
        case 3: {
            return self.roomBooking.timeIntervalList.count;
        }
        
        default: {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // 教室信息
        case 0: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.room];
            
            return cell;
        }
        // 申请人信息
        case 1: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.applicantInfo];
            
            return cell;
        }
        // 申请事由
        case 2: {
            SimpleDescriptionCell *cell = (SimpleDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell" forIndexPath:indexPath];
            
            [cell displayDescription:self.roomBooking.bookReason];
            
            return cell;
        }
        // 申请时间段
        case 3: {
            TimeIntervalCell *cell = (TimeIntervalCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeIntervalCell"];
            
            TimeInterval *timeInterval = self.roomBooking.timeIntervalList[indexPath.row];
            [cell displayTimeInterval:timeInterval];
            
            return cell;
        }
        
        default: {
            return nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [UIHelper
         showAlertViewWithTitle:@"申请事由"
         message:self.roomBooking.bookReason
         inViewController:self.navigationController];
    }
}

#pragma mark - Export actions

- (UIImage *) imageFromTableView:(UITableView *)tableView {
    UIView *renderedView = tableView;
    CGPoint tableContentOffset = tableView.contentOffset;
    UIGraphicsBeginImageContextWithOptions(renderedView.bounds.size, renderedView.opaque, 0.0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contextRef, 0, -tableContentOffset.y);
    [tableView.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)saveToAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)export {
    [self saveToAlbum:[self imageFromTableView:self.tableView]];
}

@end
