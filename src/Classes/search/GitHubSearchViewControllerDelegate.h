//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDisplayMgr.h"
#import "UserDisplayMgrFactory.h"
#import "SearchViewControllerDelegate.h"

@interface GitHubSearchViewControllerDelegate :
    NSObject <SearchViewControllerDelegate>
{
    IBOutlet UINavigationController * navigationController;
    IBOutlet UserDisplayMgrFactory * userDisplayMgrFactory;
    NSObject<UserDisplayMgr> * userDisplayMgr;
}

@property (readonly) NSObject<UserDisplayMgr> * userDisplayMgr;

@end
