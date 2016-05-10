//
//  RoomBookingViewController.m
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomBookingViewController.h"
#import "AddTimeIntervalViewController.h"
#import "SimpleDescriptionCell.h"
#import "TextInputCell.h"
#import "TimeIntervalCell.h"
#import "UserManager.h"
#import "APIManager.h"

@interface RoomBookingViewController () <SWTableViewCellDelegate, UITextViewDelegate>

@property(strong, nonatomic) Faculty *supervisor;

@property(strong, nonatomic) NSMutableOrderedSet *timeIntervalList;
@property(strong, nonatomic) UIPlaceHolderTextView *bookReasonTextView;

@end

@implementation RoomBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self checkTimeInterval];
}

/**
 *  Check added time interval and edited time interval.
 */
- (void)checkTimeInterval {
    RoomScreen *roomScreen = [RoomScreen sharedInstance];
    if (roomScreen.addedTimeInterval) {
        [self.timeIntervalList addObject:roomScreen.addedTimeInterval];
        roomScreen.addedTimeInterval = nil;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.timeIntervalList.count-1
                                                    inSection:4];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (roomScreen.editedTimeInterval) {
        roomScreen.editedTimeInterval.overlapped = NO;
        roomScreen.editedTimeInterval = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - RecyclableViewController protocol methods

- (void)initializeView {
    // Title.
    self.title = @"申请教室";
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleDescriptionCell" bundle:nil]
         forCellReuseIdentifier:@"SimpleDescriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextInputCell" bundle:nil]
         forCellReuseIdentifier:@"TextInputCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeIntervalCell" bundle:nil]
         forCellReuseIdentifier:@"TimeIntervalCell"];
    self.tableView.sectionIndexColor = [UIColor colorWithWhite:0 alpha:0];
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UIBarButtonItem *commitBookingButton = [[UIBarButtonItem alloc]
                                            initWithTitle:@"提交"
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(commitBooking)];
    self.navigationItem.rightBarButtonItem = commitBookingButton;
    
    // Add time interval button.
    UIButton *addTimeIntervalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addTimeIntervalButton.width = [GlobalConstants sharedInstance].screenWidth;
    addTimeIntervalButton.height = 44;
    [addTimeIntervalButton setTitle:@"添加" forState:UIControlStateNormal];
    [addTimeIntervalButton setTintColor:[UIColor themeColor]];
    [addTimeIntervalButton addTarget:self
                              action:@selector(addTimeInterval)
                    forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = addTimeIntervalButton;
    
    // Data.
    self.timeIntervalList = [NSMutableOrderedSet orderedSet];
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.userType == USER_TYPE_STUDENT) {
        self.supervisor = userManager.student.supervisor;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        // 申请时间段
        return self.timeIntervalList.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 100;
    } else {
        return 44;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"教室信息";
        }
        case 1: {
            return @"申请人信息";
        }
        case 2: {
            return @"已选择上级";
        }
        case 3: {
            return @"申请事由";
        }
        case 4: {
            return @"申请时间段";
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // 教室信息
        case 0: {
            SimpleDescriptionCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell"
                                   forIndexPath:indexPath];
            [cell displayDescription:self.room];
            return cell;
        }
        // 申请人信息
        case 1: {
            SimpleDescriptionCell *cell = [tableView
                                           dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell"
                                           forIndexPath:indexPath];
            [cell displayDescription:[UserManager sharedInstance].currentUser];
            return cell;
        }
        // 已选择上级
        case 2: {
            SimpleDescriptionCell *cell = [tableView
                                           dequeueReusableCellWithIdentifier:@"SimpleDescriptionCell"
                                           forIndexPath:indexPath];
            if (self.supervisor) {
                [cell displayDescription:self.supervisor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                [cell displayDescription:@"无需填写"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            return cell;
        }
        // 申请事由
        case 3: {
            TextInputCell *cell = [tableView
                                           dequeueReusableCellWithIdentifier:@"TextInputCell"
                                           forIndexPath:indexPath];
            // Get book reason text view.
            self.bookReasonTextView = cell.textView;
            self.bookReasonTextView.placeholder = @"请输入申请事由";
            self.bookReasonTextView.delegate = self;
            return cell;
        }
        // 申请时间段
        case 4: {
            TimeIntervalCell *cell = (TimeIntervalCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeIntervalCell"];
            
            if (cell.rightUtilityButtons == nil) {
                cell.rightUtilityButtons = [self timeIntervalCellRightButtons];
                cell.delegate = self;
            }
            
            TimeInterval *timeInterval = self.timeIntervalList[indexPath.row];
            [cell displayTimeInterval:timeInterval];
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 4) {
        SWTableViewCell *cell = (SWTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell showRightUtilityButtonsAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        });
    }
}

#pragma mark - Swipeable table view cell

/**
 *  Right buttons for time interval cell.
 */
- (NSArray *)timeIntervalCellRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"修改"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            // Edit.
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [self editTimeInterval:self.timeIntervalList[cellIndexPath.row]];
            break;
        }
        case 1: {
            // Delete.
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.timeIntervalList removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Text view delegate

/**
 *  Hide keyboard when hit return key.
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Add time interval action

- (void)addTimeInterval {
    [RoomScreen sharedInstance].addedTimeInterval = nil;
    AddTimeIntervalViewController *vc = [AddTimeIntervalViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editTimeInterval:(TimeInterval *)timeInterval {
    AddTimeIntervalViewController *vc = [AddTimeIntervalViewController new];
    vc.timeInterval = timeInterval;
    vc.isEdit = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Commit booking button action

- (void)commitBooking {
    NSString *bookReason = self.bookReasonTextView.text;
    if (!bookReason || [bookReason isEqualToString:@""]) {
        [UIHelper showTopAlertView:@"请输入申请事由！"
         fromViewController:self.navigationController];
        return ;
    }
    
    if (self.timeIntervalList.count == 0) {
        [UIHelper showTopAlertView:@"请添加申请时间段！"
         fromViewController:self.navigationController];
        return ;
    }
    
    // Prepare data.
    UserManager *userManager = [UserManager sharedInstance];
    NSString *facultyId = nil;
    if (userManager.userType == USER_TYPE_STUDENT) {
        facultyId = userManager.student.supervisor.facultyId;
    }
    NSString *timeIntervals =
    [TimeInterval timeIntervalJsonStringFromOrderedSet:self.timeIntervalList];
    
    // Configure hud.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在提交申请...";
    
    // Send request.
    [[APIManager sharedInstance]
     bookRoomWithRoomBuilding:self.room.building
     roomNumber:self.room.number
     applicantType:userManager.userTypeStr
     applicantId:userManager.userId
     facultyId:facultyId
     timeIntervals:timeIntervals
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSMutableDictionary.class]) {
             NSString *message = jsonData[@"message"];
             if ([message isEqualToString:@"Time interval overlaps."]) {
                 // 时间段重叠
                 NSMutableOrderedSet *timeIntervalList = [TimeInterval timeIntervalListFromJsonData:jsonData[@"overlappedIntervals"]];
                 for (TimeInterval *overlappedInterval in timeIntervalList) {
                     for (TimeInterval *interval in self.timeIntervalList) {
                         interval.overlapped = [interval isEqualToTimeInterval:overlappedInterval];
                         //DDLogError(@"%@ overlapped: %d", interval, interval.overlapped);
                     }
                 }
                 [UIHelper showTopAlertView:@"部分时间重叠，创建申请失败！"
                         fromViewController:self.navigationController];
                 
                 [self.tableView reloadData];
             } else if ([message isEqualToString:@"Successfully booked."]) {
                 // 创建申请成功
                 [UIHelper showTopAlertView:@"创建申请成功！请等待审核。"
                         fromViewController:self.navigationController];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }
         
         [hud hide:YES];
     }
     failure:^(NSError *error) {
         [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }
     timeout:^{
         [UIHelper showTopAlertView:@"等待超时！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES];
     }];
}

@end
