//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDisplayMgr.h"
#import "NewsFeedDisplayMgr.h"

@interface CodeWatchTabBarControllerDelegate :
    NSObject <UITabBarControllerDelegate>
{
    IBOutlet UserDisplayMgr * userDisplayMgr;
    IBOutlet NewsFeedDisplayMgr * newsFeedDisplayMgr;
}

@end
