//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigReader.h"
#import "LogInStateReader.h"
#import "NewsFeedCache.h"
#import "NewsFeedPersistenceStore.h"

@class LogInState, GitHubNewsFeedService;

@interface GitHubNewsFeedServiceFactory : NSObject
{
    IBOutlet NSObject<ConfigReader> * configReader;
    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NewsFeedCache * newsFeedCache;
    IBOutlet NewsFeedPersistenceStore * newsFeedPersistenceStore;
}

- (GitHubNewsFeedService *)createGitHubNewsFeedService;

@end