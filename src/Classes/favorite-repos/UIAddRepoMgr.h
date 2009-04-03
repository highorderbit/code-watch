//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddRepoMgr.h"
#import "AddRepoViewController.h"
#import "GitHubService.h"
#import "FavoriteReposStateReader.h"
#import "FavoriteReposStateSetter.h"
#import "AddRepoViewControllerDelegate.h"
#import "WebViewController.h"

@interface UIAddRepoMgr : NSObject <AddRepoMgr, AddRepoViewControllerDelegate>
{
    IBOutlet UIViewController * rootViewController;
    
    UINavigationController * navigationController;
    AddRepoViewController * addRepoViewController;
    WebViewController * helpViewController;

    IBOutlet GitHubService * gitHubService;
    IBOutlet NSObject<FavoriteReposStateSetter> * favoriteReposStateSetter;
    IBOutlet NSObject<FavoriteReposStateReader> * favoriteReposStateReader;
        
    BOOL connecting;
    NSString * repoName;
}

@property (nonatomic, copy) NSString * repoName;

// Interface Builder requires re-definition
- (IBAction)addRepo:(id)sender;

@end
