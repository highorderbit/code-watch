//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewControllerDelegate.h"
#import "NetworkAwareViewController.h"
#import "NewsFeedTableViewController.h"
#import "NewsFeedCacheReader.h"
#import "LogInStateReader.h"

@interface NewsFeedDisplayMgr : NSObject <NetworkAwareViewControllerDelegate>
{
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet NewsFeedTableViewController * newsFeedTableViewController;
    
    IBOutlet NSObject<NewsFeedCacheReader> * cacheReader;
    IBOutlet NSObject<LogInStateReader> * logInState;
}

@end
