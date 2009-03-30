//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchViewController.h"
#import "GitHubServiceFactory.h"

@interface GitHubSearchInitializer : NSObject
{
    IBOutlet SearchViewController * searchViewController;
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
}

@end
