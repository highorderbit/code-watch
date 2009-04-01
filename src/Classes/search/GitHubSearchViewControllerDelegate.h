//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDisplayMgr.h"
#import "UserDisplayMgrFactory.h"
#import "SearchViewControllerDelegate.h"
#import "RepoSelector.h"
#import "RepoSelectorFactory.h"

@interface GitHubSearchViewControllerDelegate :
    NSObject <SearchViewControllerDelegate>
{
    IBOutlet UINavigationController * navigationController;
    IBOutlet UserDisplayMgrFactory * userDisplayMgrFactory;
    IBOutlet RepoSelectorFactory * repoSelectorFactory;
    NSObject<UserDisplayMgr> * userDisplayMgr;
    NSObject<RepoSelector> * repoSelector;
}

@property (readonly) NSObject<UserDisplayMgr> * userDisplayMgr;
@property (readonly) NSObject<RepoSelector> * repoSelector;

@end
