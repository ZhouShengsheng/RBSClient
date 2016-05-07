//
//  RoomListViewController.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomListViewController.h"
#import "Utils.h"
#import "RoomListCell.h"
#import "Room.h"
#import "APIManager.h"

@interface RoomListViewController ()

@property (strong, nonatomic) NSMutableArray<Room *> *roomList;

@end

@implementation RoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"教室列表";
    [self.tableView registerNib:[UINib nibWithNibName:@"RoomListCell" bundle:nil]
         forCellReuseIdentifier:@"RoomListCell"];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectMake(0, 0, 0,
                                                               [GlobalConstants sharedInstance].tabBarHeight)];
    
    self.roomList = [NSMutableArray array];
    [self loadData];
}

- (void)loadData {
    [[APIManager sharedInstance]
     getRoomListWithBuilding:nil
     fromIndex:self.roomList.count
     success:^(id jsonData) {
         NSArray *array = (NSArray *)jsonData;
         for (int i = 0; i < array.count; i++) {
             NSDictionary *roomData = array[i];
             Room *room = [Room new];
             room.building = roomData[@"building"];
             room.number = roomData[@"number"];
             room.capacity = [roomData[@"capacity"] unsignedIntegerValue];
             room.hasMultiMedia = [roomData[@"hasmultimedia"] unsignedIntegerValue];
             [self.roomList addObject:room];
         }
         [self.tableView reloadData];
     }
     failure:^(NSError *error) {
         
     }
     timeout:^{
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomListCell *cell = (RoomListCell *)[tableView dequeueReusableCellWithIdentifier:@"RoomListCell"
                                                            forIndexPath:indexPath];
    
    Room *room = self.roomList[indexPath.row];
    cell.buildingNumberLabel.text = [room.building stringByAppendingString:room.number];
    cell.infoLabel.text = [NSString stringWithFormat:@"%u人 %@多媒体设备",
                           room.capacity, room.hasMultiMedia ? @"有": @"无"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DDLogError(@"clicked %ld", (long)indexPath.row);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
