//
//  DDLog.h
//  iJuGou
//
//  Created by Shengsheng on 17/2/16.
//  Copyright © 2016 CAP_NTU. All rights reserved.
//

#ifndef DDLog_h
#define DDLog_h

#import "CocoaLumberjack.h"

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

/**
 *  Init logger.
 */
void initDDLogger();

/**
 *  If it's not in debug mode, disable all the log functions.
 */
#ifndef DEBUG

#undef DDLogError
#define DDLogError(frmt, ...)

#undef DDLogWarn
#define DDLogWarn(frmt, ...)

#undef DDLogDebug
#define DDLogDebug(frmt, ...)

#undef DDLogInfo
#define DDLogInfo(frmt, ...)

#undef DDLogVerbose
#define DDLogVerbose(frmt, ...)

#endif

#endif /* DDLog_h */
