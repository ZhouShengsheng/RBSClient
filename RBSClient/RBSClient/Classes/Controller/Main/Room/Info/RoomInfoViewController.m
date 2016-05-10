//
//  RoomInfoViewController.m
//  RBSClient
//
//  Created by Shengsheng on 10/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomInfoViewController.h"
#import "RoomBasicInfoCell.h"
#import "TimeIntervalCell.h"
#import "APIManager.h"
#import "UserManager.h"
#import "RoomBookingViewController.h"

@interface RoomInfoViewController ()

// Room.
@property(strong, nonatomic) Room *room;
// Time interval list.
@property(strong, nonatomic) NSMutableOrderedSet *timeIntervalList;

@property (strong, nonatomic) MJRefreshNormalHeader *header;
@property (strong, nonatomic) UIButton *favoriteButton;

@end

@implementation RoomInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

/**
 *  Load data from server.
 */
- (void)loadData {
    UserManager *userManager = [UserManager sharedInstance];
    [[APIManager sharedInstance]
     getRoomInfoWithUserType:userManager.userTypeStr
     userId:userManager.userId
     building:self.building
     number:self.number
     success:^(id jsonData) {
         [self.header endRefreshing];
         
         NSString *message = jsonData[@"message"];
         if (message) {
             return ;
         }
         
         // Basic info.
         NSDictionary *basicInfo = jsonData[@"basicInfo"];
         self.room = [[Room alloc] initWithJsonData:basicInfo];
         
         // Is favorite.
         self.room.isFavorite = [jsonData[@"isFavorite"] boolValue];
         [self updateFavoriteButton];
         
         // Booked time intervals.
         self.timeIntervalList = [TimeInterval timeIntervalListFromJsonData:jsonData[@"timeIntervals"]];
         
         [self.tableView reloadData];
     }
     failure:^(NSError *error) {
         [self.header endRefreshing];
     }
     timeout:^{
         [self.header endRefreshing];
     }];
}

- (void)refresh {
    [self loadData];
}

- (void)updateFavoriteButton {
    if (self.room.isFavorite) {
        //self.favoriteButton.image = [UIImage imageNamed:@"icon_favorite"];
        [self.favoriteButton setImage:[UIImage imageNamed:@"icon_favorite"]
                             forState:UIControlStateNormal];
    } else {
        //self.favoriteButton.image = [UIImage imageNamed:@"icon_not_favorite"];
        [self.favoriteButton setImage:[UIImage imageNamed:@"icon_not_favorite"]
                             forState:UIControlStateNormal];
    }
}

#pragma mark - RecyclableViewController protocol methods
- (void)initializeView {
    // Title.
    self.title = [NSString stringWithFormat:@"%@%@", self.building, self.number];
    
    // Table view.
    [self.tableView registerNib:[UINib nibWithNibName:@"RoomBasicInfoCell" bundle:nil]
         forCellReuseIdentifier:@"RoomBasicInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeIntervalCell" bundle:nil]
         forCellReuseIdentifier:@"TimeIntervalCell"];
    self.tableView.sectionIndexColor = [UIColor colorWithWhite:0 alpha:0];
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.tableView.tableFooterView = [UIView new];
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    // Book button.
    UIBarButtonItem *bookButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"申请"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(bookRoom)];
    // Favorite button.
    self.favoriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.favoriteButton setImage:[UIImage imageNamed:@"icon_not_favorite"]
            forState:UIControlStateNormal];
    self.favoriteButton.width = 21;
    self.favoriteButton.height = 21;
    [self.favoriteButton addTarget:self
                            action:@selector(favorite)
                  forControlEvents:UIControlEventTouchUpInside];
    self.favoriteButton.tintColor = [UIColor alertColor];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:self.favoriteButton];
    self.navigationItem.rightBarButtonItems = @[bookButton, button];
    
    // Init header.
    self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
    self.tableView.mj_header = self.header;
    [self.header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"基本信息";
        }
        case 1: {
            return @"已被申请时间段";
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 1;
        }
        case 1: {
            return self.timeIntervalList.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            RoomBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomBasicInfoCell" forIndexPath:indexPath];
            if (self.room) {
                [cell displayRoom:self.room];
            }
            return cell;
        }
        case 1: {
            TimeIntervalCell *cell = (TimeIntervalCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeIntervalCell"];
            
            TimeInterval *timeInterval = self.timeIntervalList[indexPath.row];
            [cell displayTimeInterval:timeInterval];
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 113;
    } else {
        return 44;
    }
}

# pragma mark - Button actions

- (void)bookRoom {
    RoomBookingViewController *vc = [RoomBookingViewController new];
    vc.room = self.room;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)favorite {
    if (!self.room.isFavorite) {
        UserManager *userManager = [UserManager sharedInstance];
        [[APIManager sharedInstance]
         setFavoriteRoomWithUserType:userManager.userTypeStr
         userId:userManager.userId
         building:self.building
         number:self.number
         success:^(id jsonData) {
             if ([jsonData[@"message"] isEqualToString:@"Successfully set favorite."]) {
                 self.room.isFavorite = YES;
                 [self updateFavoriteButton];
             }
         }
         failure:^(NSError *error) {
             
         }
         timeout:^{
             
         }];
    } else {
        UserManager *userManager = [UserManager sharedInstance];
        [[APIManager sharedInstance]
         unsetFavoriteRoomWithUserType:userManager.userTypeStr
         userId:userManager.userId
         building:self.building
         number:self.number
         success:^(id jsonData) {
             if ([jsonData[@"message"] isEqualToString:@"Successfully unset favorite."]) {
                 self.room.isFavorite = NO;
                 [self updateFavoriteButton];
             }
         }
         failure:^(NSError *error) {
             
         }
         timeout:^{
             
         }];
    }
}

@end
