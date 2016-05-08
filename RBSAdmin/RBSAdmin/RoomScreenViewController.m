//
//  RoomScreenViewController.m
//  RBSAdmin
//
//  Created by Shengsheng on 8/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomScreenViewController.h"
#import "CheckableCell.h"
#import "AddTimeIntervalViewController.h"

@interface RoomScreenViewController () <SWTableViewCellDelegate>

@property(strong, nonatomic) RoomScreen *tempRoomScreen;

@property(strong, nonatomic) NSMutableArray *buildingList;
@property(strong, nonatomic) NSMutableArray *capacityList;
@property(strong, nonatomic) NSMutableArray *multiMediaList;

@property(strong, nonatomic) NSMutableArray<BEMCheckBox *> *capacityCheckBoxList;

@end

@implementation RoomScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    // Check added time interval and edited time interval.
    RoomScreen *roomScreen = [RoomScreen sharedInstance];
    if (roomScreen.addedTimeInterval) {
        [self.tempRoomScreen.timeIntervalList addObject:roomScreen.addedTimeInterval];
        roomScreen.addedTimeInterval = nil;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tempRoomScreen.timeIntervalList.count-1
                                                    inSection:3];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (roomScreen.editedTimeInterval) {
        roomScreen.editedTimeInterval = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - RecyclableViewController protocol methods
- (void)initializeView {
    // Title.
    self.title = @"筛选教室";
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckableCell" bundle:nil]
         forCellReuseIdentifier:@"CheckableCell"];
    self.tableView.sectionIndexColor = [UIColor colorWithWhite:0 alpha:0];
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UIBarButtonItem *saveScreenButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"确认"
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(saveScreen)];
    self.navigationItem.rightBarButtonItem = saveScreenButton;
    
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
    self.tempRoomScreen = [[RoomScreen sharedInstance] copy];
    self.buildingList = [NSMutableArray array];
    [self.buildingList addObject:@"软件楼"];
    [self.buildingList addObject:@"图书馆"];
    self.capacityList = [NSMutableArray array];
    [self.capacityList addObject:@10];
    [self.capacityList addObject:@20];
    [self.capacityList addObject:@30];
    [self.capacityList addObject:@40];
    [self.capacityList addObject:@50];
    [self.capacityList addObject:@60];
    self.multiMediaList = [NSMutableArray array];
    [self.multiMediaList addObject:@"有"];
    [self.multiMediaList addObject:@"无"];
    
    self.capacityCheckBoxList = [NSMutableArray array];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"楼栋";
        }
        case 1: {
            return @"容量";
        }
        case 2: {
            return @"多媒体";
        }
        case 3: {
            return @"空闲时间段";
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        // 楼栋
        case 0: {
            return self.buildingList.count;
        }
        // 容量
        case 1: {
            return self.capacityList.count;
        }
        // 多媒体
        case 2: {
            return self.multiMediaList.count;
        }
        // 空闲时间段
        case 3: {
            return self.tempRoomScreen.timeIntervalList.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomScreen *roomScreen = [RoomScreen sharedInstance];
    switch (indexPath.section) {
        // 楼栋
        case 0: {
            CheckableCell *cell = [tableView
                                     dequeueReusableCellWithIdentifier:@"CheckableCell"
                                     forIndexPath:indexPath];
            cell.choiceLabel.text = self.buildingList[indexPath.row];
            cell.checkBox.superview.tag = indexPath.section;
            cell.checkBox.tag = indexPath.row;
            cell.checkBox.delegate = self;
            if ([roomScreen.buildingList containsObject:self.buildingList[indexPath.row]]) {
                [cell.checkBox setOn:YES animated:NO];
            } else {
                [cell.checkBox setOn:NO animated:NO];
            }
            return cell;
        }
        // 容量
        case 1: {
            CheckableCell *cell = [tableView
                                     dequeueReusableCellWithIdentifier:@"CheckableCell"
                                     forIndexPath:indexPath];
            cell.choiceLabel.text = [NSString stringWithFormat:@"%@人", self.capacityList[indexPath.row]];
            cell.checkBox.superview.tag = indexPath.section;
            cell.checkBox.tag = indexPath.row;
            cell.checkBox.delegate = self;
            if (roomScreen.capacity == [self.capacityList[indexPath.row] unsignedIntegerValue]) {
                [cell.checkBox setOn:YES animated:NO];
            } else {
                [cell.checkBox setOn:NO animated:NO];
            }
            [self.capacityCheckBoxList addObject:cell.checkBox];
            return cell;
        }
        // 多媒体
        case 2: {
            CheckableCell *cell = [tableView
                                     dequeueReusableCellWithIdentifier:@"CheckableCell"
                                     forIndexPath:indexPath];
            cell.choiceLabel.text = self.multiMediaList[indexPath.row];
            cell.checkBox.superview.tag = indexPath.section;
            cell.checkBox.tag = indexPath.row;
            cell.checkBox.delegate = self;
            if ([roomScreen.hasMultiMediaList containsObject:self.multiMediaList[indexPath.row]]) {
                [cell.checkBox setOn:YES animated:NO];
            } else {
                [cell.checkBox setOn:NO animated:NO];
            }
            return cell;
        }
        // 空闲时间段
        case 3: {
            SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeIntervalCell"];
            
            if (cell == nil) {
                cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TimeIntervalCell"];
                cell.rightUtilityButtons = [self timeIntervalCellRightButtons];
                cell.delegate = self;
            }
            
            TimeInterval *timeInterval = self.tempRoomScreen.timeIntervalList[indexPath.row];
            cell.textLabel.text = [timeInterval description];
            
            return cell;
        }
    }
    
    return nil;
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
                                                title:@"编辑"];
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
            [self editTimeInterval:self.tempRoomScreen.timeIntervalList[cellIndexPath.row]];
            break;
        }
        case 1: {
            // Delete.
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.tempRoomScreen.timeIntervalList removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

#pragma mark - BEMCheckBox delegate

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    NSUInteger section = checkBox.superview.tag;
    NSUInteger row = checkBox.tag;
    //DDLogError(@"(%u,%u)", section, row);
    switch (section) {
        // 楼栋
        case 0: {
            if (checkBox.on) {
                [self.tempRoomScreen.buildingList addObject:self.buildingList[row]];
            } else {
                [self.tempRoomScreen.buildingList removeObject:self.buildingList[row]];
            }
            break;
        }
        // 容量
        case 1: {
            if (checkBox.on) {
                self.tempRoomScreen.capacity = [self.capacityList[row] unsignedIntegerValue];
            } else {
                self.tempRoomScreen.capacity = 0;
            }
            
            
            if (!checkBox.on) {
                return ;
            }
            
            // Keep single selection for capacity group.
            for (BEMCheckBox *box in self.capacityCheckBoxList) {
                if (box != checkBox && box.on) {
                    [box setOn:NO animated:YES];
                }
            }
            break;
        }
        // 多媒体
        case 2: {
            if (checkBox.on) {
                [self.tempRoomScreen.hasMultiMediaList addObject:self.multiMediaList[row]];
            } else {
                [self.tempRoomScreen.hasMultiMediaList removeObject:self.multiMediaList[row]];
            }
            break;
        }
    }
}

- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox {
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

#pragma mark - Save screen action
- (void)saveScreen {
    DDLogError(@"tempRoomScreen: %@", self.tempRoomScreen);
    [RoomScreen updateSharedInstance:self.tempRoomScreen];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
