//
//  DDLog.c
//  iJuGou
//
//  Created by Shengsheng on 17/2/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#include "DDLog.h"
#include "AppDelegate.h"

static BOOL isInitialized = NO;

void initDDLogger() {
    @synchronized([AppDelegate delegate]) {
        if(isInitialized) {
            return ;
        }
        // Enable XcodeColors
        setenv("XcodeColors", "YES", 0);
        
        // Standard lumberjack initialization
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        // And then enable colors
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        
        // Customize logger colors
#if TARGET_OS_IPHONE
        UIColor *red = [UIColor redColor];
        UIColor *green = [UIColor greenColor];
        UIColor *blue = [UIColor blueColor];
        UIColor *black = [UIColor blackColor];
#else
        NSColor *red = [NSColor colorWithCalibratedRed:(255/255.0)
                                                 green:(0/255.0)
                                                  blue:(0/255.0)
                                                 alpha:1.0];
        NSColor *green = [NSColor colorWithCalibratedRed:(0/255.0)
                                                   green:(255/255.0)
                                                    blue:(0/255.0)
                                                   alpha:1.0];
        NSColor *blue = [NSColor colorWithCalibratedRed:(0/255.0)
                                                  green:(0/255.0)
                                                   blue:(255/255.0)
                                                  alpha:1.0];
        NSColor *black = [NSColor colorWithCalibratedRed:(0/255.0)
                                                   green:(0/255.0)
                                                    blue:(0/255.0)
                                                   alpha:1.0];
#endif

        DDTTYLogger *logger = [DDTTYLogger sharedInstance];
        [logger setForegroundColor:red backgroundColor:nil forFlag:DDLogFlagError];
        [logger setForegroundColor:blue backgroundColor:nil forFlag:DDLogFlagWarning];
        [logger setForegroundColor:green backgroundColor:nil forFlag:DDLogFlagDebug];
        [logger setForegroundColor:black backgroundColor:nil forFlag:DDLogFlagInfo];
        
#ifdef DEBUG
        DDLogDebug(@"😎 Debug mode.");
#else
        DDLogInfo(@"😄 Release mode.");
#endif
        
        isInitialized = YES;
    }
}