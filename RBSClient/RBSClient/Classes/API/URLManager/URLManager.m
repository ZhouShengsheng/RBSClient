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
}

@end
