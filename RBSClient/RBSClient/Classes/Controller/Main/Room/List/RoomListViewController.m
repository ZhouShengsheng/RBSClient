//
//  RoomListViewController.m
//  RBSAdmin
//
//  Created by Shengsheng on 7/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "RoomListViewController.h"
#import "RoomListCell.h"
#import "APIManager.h"
#import "RoomScreenViewController.h"
#import "RoomSearchViewController.h"
#import "RoomInfoViewController.h"

@interface RoomListViewController ()

@property (strong, nonatomic) NSMutableArray<Room *> *roomList;
@property (assign, nonatomic) BOOL noMoreData;

@property (strong, nonatomic) MJRefreshNormalHeader *header;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;

@property(strong, nonatomic) RoomScreen *tempRoomScreen;

@end

@implementation RoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tempRoomScreen = [RoomScreen sharedInstance];
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    // Check room screen update.
    RoomScreen *roomScreen = [RoomScreen sharedInstance];
    if (self.tempRoomScreen != roomScreen) {
        self.tempRoomScreen = roomScreen;
        [self.header beginRefreshing];
    }
}

/**
 *  Load data from server.
 */
- (void)loadData {
    NSString *building = nil;
    if (self.tempRoomScreen.buildingList &&
        self.tempRoomScreen.buildingList.count == 1) {
        building = self.tempRoomScreen.buildingList.firstObject;
    }
    
    NSNumber *hasMultiMedia = nil;
    if (self.tempRoomScreen.hasMultiMediaList &&
        self.tempRoomScreen.hasMultiMediaList.count == 1) {
        NSString *hasOrNot = self.tempRoomScreen.hasMultiMediaList.firstObject;
        if ([hasOrNot isEqualToString:@"有"]) {
            hasMultiMedia = @1;
        } else {
            hasMultiMedia = @0;
        }
    }
    
    NSString *timeIntervals =
    [TimeInterval timeIntervalJsonStringFromOrderedSet:self.tempRoomScreen.timeIntervalList];
    
    [[APIManager sharedInstance]
     getRoomListWithBuilding:building
     capacity:self.tempRoomScreen.capacity
     hasMultiMedia:hasMultiMedia
     timeIntervals:timeIntervals
     fromIndex:self.roomList.count
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             [self.header endRefreshing];
             [self.footer endRefreshing];
             return ;
         }
         NSArray *array = (NSArray *)jsonData;
         NSUInteger count = array.count;
         if (count < defaultPageSize) {
             self.noMoreData = YES;
             [self.footer endRefreshingWithNoMoreData];
         } else {
             [self.footer endRefreshing];
         }
         for (NSUInteger i = 0; i < count; i++) {
             [self.roomList addObject:[[Room alloc] initWithJsonData:array[i]]];
         }
         [self.tableView reloadData];
         [self.header endRefreshing];
         self.tableView.mj_footer = self.footer;
     }
     failure:^(NSError *error) {
         [self.header endRefreshing];
         [self.footer endRefreshing];
     }
     timeout:^{
         [self.header endRefreshing];
         [self.footer endRefreshing];
     }];
}

#pragma mark - RecyclableViewController protocol methods
- (void)initializeView {
    // Title.
    self.title = @"教室列表";
    
    // Navigation bar buttons.
    UIBarButtonItem *screenButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@"icon_screen"]
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(screenButtonTapped)];
    screenButton.tintColor = [UIColor themeColor];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@"icon_search"]
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(searchButtonTapped)];
    searchButton.tintColor = [UIColor themeColor];
    self.navigationItem.rightBarButtonItems = @[searchButton, screenButton];
    
    // Init room list array.
    self.roomList = [NSMutableArray array];
    
    // Register table view cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"RoomListCell" bundle:nil]
         forCellReuseIdentifier:@"RoomListCell"];
    self.tableView.tableFooterView = [UIView new];
    
    // Init header and footer.
    self.header = [UIHelper refreshHeaderWithTarget:self action:@selector(refresh)];
    self.tableView.mj_header = self.header;
    
    self.footer = [UIHelper refreshFooterWithTarget:self action:@selector(loadMore)];
    [self.header beginRefreshing];
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
    
    [cell displayWithRoom:self.roomList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Room *room = self.roomList[indexPath.row];
    RoomInfoViewController *vc = [RoomInfoViewController new];
    vc.building = room.building;
    vc.number = room.number;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Header and footer actions
/**
 *  Pull down to refresh.
 */
- (void)refresh {
    self.noMoreData = NO;
    self.tableView.mj_footer = nil;
    
    [self.roomList removeAllObjects];
    [self.tableView reloadData];
    
    // Load data from server.
    [self loadData];
}

/**
 *  Load more.
 */
- (void)loadMore {
    if (self.noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadData];
    }
}

#pragma mark - Button actions

/**
 *  Screen.
 */
- (void)screenButtonTapped {
    RoomScreenViewController *vc = [RoomScreenViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  Search.
 */
- (void)searchButtonTapped {
    RoomSearchViewController *vc = [RoomSearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
