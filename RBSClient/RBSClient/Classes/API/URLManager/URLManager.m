//
//  URLManager.m
//  RBSAdmin
//
//  Created by Shengsheng on 21/3/16.
//  Copyright © 2016 NTU. All rights reserved.
//

#import "URLManager.h"

@implementation URLManager

+ (instancetype)sharedInstance {
    static URLManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        [instance initUrls];
    });
    return instance;
}

- (NSString *)formUrlWithRoute:(NSString *)route {
    return [NSString stringWithFormat:@"%@%@",
            server, route];
}

- (void)initUrls {
    // User.
    _loginURL = [self formUrlWithRoute:@"/user/login"];
    _updateUserInfoURL = [self formUrlWithRoute:@"/user/update"];
    _changePasswordURL = [self formUrlWithRoute:@"/user/change_password"];
    
    // Room.
    _roomListURL = [self formUrlWithRoute:@"/room/list"];
    _searchRoomListURL = [self formUrlWithRoute:@"/room/search"];
    _roomInfoURL = [self formUrlWithRoute:@"/room/info"];
    _setFavoriteURL = [self formUrlWithRoute:@"/room/set_favorite"];
    _unsetFavoriteURL = [self formUrlWithRoute:@"/room/unset_favorite"];
    _clearFavoriteURL = [self formUrlWithRoute:@"/room/clear_favorite"];
    _favoriteListURL = [self formUrlWithRoute:@"/room/favorite_list"];
    
    // Room book.
    _bookRoomURL = [self formUrlWithRoute:@"/room_booking/book"];
    _studentBookingListURL = [self formUrlWithRoute:@"/room_booking/student_booking_list"];
    _roomBookingInfoURL = [self formUrlWithRoute:@"/room_booking/info"];
    
    // Supervisor.
    _checkSupervisorURL = [self formUrlWithRoute:@"/supervisor/check"];
    _supervisorListURL = [self formUrlWithRoute:@"/supervisor/list"];
    _addSupervisorURL = [self formUrlWithRoute:@"/supervisor/add"];
    _removeSupervisorURL = [self formUrlWithRoute:@"/supervisor/delete"];
    _searchSupervisorURL = [self formUrlWithRoute:@"/supervisor/search"];
}

@end
