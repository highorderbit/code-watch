//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeWatchDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "NewsFeedTableViewController.h"
#import "NewsFeedCacheReader.h"
#import "LogInStateReader.h"

@interface NewsFeedDisplayMgr : NSObject <CodeWatchDisplayMgr>
{
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet NewsFeedTableViewController * newsFeedTableViewController;
    
    IBOutlet NSObject<NewsFeedCacheReader> * cacheReader;
    IBOutlet NSObject<LogInStateReader> * logInState;
}

@end
