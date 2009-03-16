//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewController.h"
#import "UserViewController.h"
#import "UserCacheReader.h"
#import "LogInStateReader.h"
#import "GitHub.h"
#import "CodeWatchDisplayMgr.h"

@interface UserDisplayMgr : NSObject <CodeWatchDisplayMgr, GitHubDelegate> {
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet UserViewController * userViewController;
    
    IBOutlet NSObject<UserCacheReader> * userCache;
    IBOutlet NSObject<LogInStateReader> * logInState;
    
    GitHub * gitHub;
}

@end
