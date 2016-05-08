//
//  AddTimeIntervalViewController.m
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "AddTimeIntervalViewController.h"
#import "Models.h"

@interface AddTimeIntervalViewController () <SWTableViewCellDelegate>

@end

@implementation AddTimeIntervalViewController

- (instancetype)init {
    if (self = [super init]) {
        self.timeInterval = [TimeInterval new];
        self.timeInterval.from = [NSDate date];
        self.timeInterval.to = [self.timeInterval.from dateByAddingTimeInterval:3600 * 2];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

#pragma mark - RecyclableViewController protocol methods
- (void)initializeView {
    // Title.
    self.title = @"添加时间段";
    
    // Add button.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"添加"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(addTimeInterval)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"日期";
        }
        case 1: {
            return @"起始时间";
        }
        case 2: {
            return @"结束时间";
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AddTimeIntervalCell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView
                                                dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    }
    
    cell.tag = indexPath.section;
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = [self.timeInterval date];
            break;
        }
        case 1: {
            cell.textLabel.text = [self.timeInterval fromTime];
            break;
        }
        case 2: {
            cell.textLabel.text = [self.timeInterval toTime];
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0: {
            ActionSheetDatePicker *timePicker =
            [[ActionSheetDatePicker alloc]
              initWithTitle:@"请选择日期"
              datePickerMode:UIDatePickerModeDate
              selectedDate:self.timeInterval.from
              doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                  self.timeInterval.from = selectedDate;
                  [tableView reloadData];
              }
              cancelBlock:^(ActionSheetDatePicker *picker) {
                  
              }
              origin:self.view];
            [self customizeTimePicker:timePicker];
            [timePicker showActionSheetPicker];
            break;
        }
        case 1: {
            ActionSheetDatePicker *timePicker =
            [[ActionSheetDatePicker alloc]
             initWithTitle:@"请选择时间"
             datePickerMode:UIDatePickerModeTime
             selectedDate:self.timeInterval.from
             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                 self.timeInterval.from = selectedDate;
                 [tableView reloadData];
             }
             cancelBlock:^(ActionSheetDatePicker *picker) {
                 
             }
             origin:self.view];
            [self customizeTimePicker:timePicker];
            [timePicker showActionSheetPicker];
            break;
        }
        case 2: {
            ActionSheetDatePicker *timePicker =
            [[ActionSheetDatePicker alloc]
             initWithTitle:@"请选择时间"
             datePickerMode:UIDatePickerModeTime
             selectedDate:self.timeInterval.to
             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                 self.timeInterval.to = selectedDate;
                 [tableView reloadData];
             }
             cancelBlock:^(ActionSheetDatePicker *picker) {
                 
             }
             origin:self.view];
            [self customizeTimePicker:timePicker];
            [timePicker showActionSheetPicker];
            break;
        }
    }
}

#pragma mark - Time interval cell right buttons
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"编辑"];
    
    return rightUtilityButtons;
}

#pragma mark - Add action

- (void)addTimeInterval {
    if (self.isEdit) {
        [RoomScreen sharedInstance].editedTimeInterval = self.timeInterval;
    } else {
        [RoomScreen sharedInstance].addedTimeInterval = self.timeInterval;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  Customize time picker to show chinese.
 */
- (void)customizeTimePicker:(ActionSheetDatePicker *)timePicker {
    timePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确认"  style:UIBarButtonItemStylePlain target:nil action:nil];
    [doneButton setStyle:UIBarButtonItemStyleDone];
    [timePicker setDoneButton:doneButton];
    [timePicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消"  style:UIBarButtonItemStylePlain target:nil action:nil]];
}

@end
