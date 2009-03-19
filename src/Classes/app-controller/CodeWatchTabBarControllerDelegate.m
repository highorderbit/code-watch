//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "CodeWatchTabBarControllerDelegate.h"

enum CodeWatchTabs {
    kHome,
    kUser,
    kUsers,
    kBookmarks,
    kSearch
};

@implementation CodeWatchTabBarControllerDelegate

- (void)dealloc
{
    [userDisplayMgr release];
    [newsFeedDisplayMgr release];
    [super dealloc];
}

- (void)tabBarController:(UITabBarController *)tabBarController
    didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.selectedIndex) {
        case kHome:
            NSLog(@"Home tab selected");
            [newsFeedDisplayMgr display];
            break;
        case kUser:
            NSLog(@"User tab selected");
            [userDisplayMgr display];
            break;
        case kUsers:
            NSLog(@"Users tab selected");
            break;
        case kBookmarks:
            NSLog(@"Bookmarks tab selected");
            break;
        case kSearch:
            NSLog(@"Search tab selected");
            break;
    }
}

@end
