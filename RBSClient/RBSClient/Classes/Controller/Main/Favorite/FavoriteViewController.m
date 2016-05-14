//
//  FavoriteViewController.m
//  RBSClient
//
//  Created by Shengsheng on 9/5/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "FavoriteViewController.h"
#import "Utils.h"
#import "RoomListCell.h"
#import "Room.h"
#import "APIManager.h"
#import "UserManager.h"
#import "Venders.h"
#import "RoomScreenViewController.h"
#import "RoomSearchViewController.h"
#import "RoomInfoViewController.h"

@interface FavoriteViewController () <SWTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray<Room *> *roomList;
@property (assign, nonatomic) BOOL noMoreData;

@property (strong, nonatomic) MJRefreshNormalHeader *header;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

/**
 *  Load data from server.
 */
- (void)loadData {
    UserManager *userManager = [UserManager sharedInstance];
    
    [[APIManager sharedInstance]
     getFavoriteRoomListWithUserType:userManager.userTypeStr
     userId:userManager.userId
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
    self.title = @"收藏列表";
    
    // Init room list array.
    self.roomList = [NSMutableArray array];
    
    // Register table view cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"RoomListCell" bundle:nil]
         forCellReuseIdentifier:@"RoomListCell"];
    self.tableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *saveScreenButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"清空"
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(clearFavorite)];
    self.navigationItem.rightBarButtonItem = saveScreenButton;
    
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
    
    if (!cell.rightUtilityButtons) {
        cell.rightUtilityButtons = [self cellRightButtons];
        cell.delegate = self;
    }
    
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

#pragma mark - Swipeable table view cell

/**
 *  Right buttons.
 */
- (NSArray *)cellRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        // Cancel favorite.
        case 0: {
            // Configure hud.
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"正在取消收藏...";
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            Room *room = self.roomList[cellIndexPath.row];
            UserManager *userManager = [UserManager sharedInstance];
            [[APIManager sharedInstance]
             unsetFavoriteRoomWithUserType:userManager.userTypeStr
             userId:userManager.userId
             building:room.building
             number:room.number
             success:^(id jsonData) {
                 if ([jsonData[@"message"] isEqualToString:@"Successfully unset favorite."]) {
                     // Delete cell.
                     NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                     
                     [self.roomList removeObjectAtIndex:cellIndexPath.row];
                     [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                           withRowAnimation:UITableViewRowAnimationAutomatic];
                 } else {
                     [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                             fromViewController:self.navigationController];
                 }
                 [hud hide:YES afterDelay:0.2];
             }
             failure:^(NSError *error) {
                 [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                         fromViewController:self.navigationController];
                 [hud hide:YES afterDelay:0.2];
             }
             timeout:^{
                 [UIHelper showTopAlertView:@"等待超时！请稍后重试！"
                         fromViewController:self.navigationController];
                 [hud hide:YES afterDelay:0.2];
             }];
            break;
        }
    }
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

#pragma mark - Favorite actions

/**
 *  Cancel favorite for a single room.
 */
- (void)cancelFavorite:(UITableViewCell *)cell {
    // Configure hud.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在取消收藏...";
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    Room *room = self.roomList[cellIndexPath.row];
    UserManager *userManager = [UserManager sharedInstance];
    [[APIManager sharedInstance]
     unsetFavoriteRoomWithUserType:userManager.userTypeStr
     userId:userManager.userId
     building:room.building
     number:room.number
     success:^(id jsonData) {
         if ([jsonData isKindOfClass:NSDictionary.class]) {
             if ([jsonData[@"message"] isEqualToString:@"Successfully unset favorite."]) {
                 // Delete cell.
                 NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                 
                 [self.roomList removeObjectAtIndex:cellIndexPath.row];
                 [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
             } else {
                 [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                         fromViewController:self.navigationController];
             }
         } else {
             [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                     fromViewController:self.navigationController];
         }
         
         [hud hide:YES afterDelay:0.2];
     }
     failure:^(NSError *error) {
         [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES afterDelay:0.2];
     }
     timeout:^{
         [UIHelper showTopAlertView:@"等待超时！请稍后重试！"
                 fromViewController:self.navigationController];
         [hud hide:YES afterDelay:0.2];
     }];
}

/**
 *  Clear favorite rooms.
 */
- (void)clearFavorite {
    PopupView *logoutPopup = [UIHelper popupViewWithMessage:@"是否确认确认清空收藏？"];
    logoutPopup.confirmButtonPressedBlock = ^(void) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在清空收藏...";
        
        UserManager *userManager = [UserManager sharedInstance];
        [[APIManager sharedInstance]
         clearFavoriteRoomWithUserType:userManager.userTypeStr
         userId:userManager.userId
         success:^(id jsonData) {
             if ([jsonData isKindOfClass:NSDictionary.class]) {
                 if ([jsonData[@"message"] isEqualToString:@"Successfully cleared favorite."]) {
                     [self.roomList removeAllObjects];
                     [self.tableView reloadData];
                     
                     [UIHelper showTopSuccessView:@"清空成功！"
                               fromViewController:self.navigationController];
                 } else {
                     [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                             fromViewController:self.navigationController];
                 }
             } else {
                 [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                         fromViewController:self.navigationController];
             }
             [hud hide:YES afterDelay:0.2];
             
         }
         failure:^(NSError *error) {
             [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                     fromViewController:self.navigationController];
             [hud hide:YES afterDelay:0.2];
             
         }
         timeout:^{
             [UIHelper showTopAlertView:@"服务器错误！请稍后重试！"
                     fromViewController:self.navigationController];
             [hud hide:YES afterDelay:0.2];
         }];
    };
}

@end
