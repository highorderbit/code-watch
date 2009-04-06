//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddUserMgr.h"
#import "AddUserViewControllerDelegate.h"
#import "AddUserViewController.h"
#import "GitHubService.h"
#import "FavoriteUsersStateSetter.h"
#import "FavoriteUsersStateReader.h"
#import "WebViewController.h"

@interface UIAddUserMgr :
    NSObject <AddUserMgr, AddUserViewControllerDelegate, GitHubServiceDelegate>
{
    IBOutlet UIViewController * rootViewController;
    
    UINavigationController * navigationController;
    AddUserViewController * addUserViewController;
    WebViewController * helpViewController;

    IBOutlet GitHubService * gitHub;
    IBOutlet NSObject<FavoriteUsersStateSetter> * favoriteUsersStateSetter;
    IBOutlet NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
        
    NSString * expectedUsername;
}

@property (nonatomic, copy) NSString * expectedUsername;

// Interface Builder requires re-definition
- (IBAction)addUser:(id)sender;

@end
