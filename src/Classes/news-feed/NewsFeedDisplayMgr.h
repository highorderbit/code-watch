//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeWatchDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "NewsFeedCacheReader.h"

@interface NewsFeedDisplayMgr : NSObject <CodeWatchDisplayMgr>
{
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet NSObject<NewsFeedCacheReader> * cacheReader;
}

@end
