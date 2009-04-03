//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubNewsFeedServiceDelegate.h"
#import "GitHubNewsFeedDelegate.h"

#import "LogInStateReader.h"
#import "NewsFeedCacheSetter.h"
#import "ConfigReader.h"

@class GitHubNewsFeed;

@interface GitHubNewsFeedService : NSObject <GitHubNewsFeedDelegate>
{
    id<GitHubNewsFeedServiceDelegate> delegate;

    NSObject<LogInStateReader> * logInStateReader;
    NSObject<NewsFeedCacheSetter> * newsFeedCacheSetter;

    GitHubNewsFeed * newsFeed;
}

@property (nonatomic, retain) id<GitHubNewsFeedServiceDelegate> delegate;

#pragma mark Initialization

- (id)initWithBaseUrl:(NSString *)baseUrl
     logInStateReader:(NSObject<LogInStateReader> *)aLogInStateReader
  newsFeedCacheSetter:(NSObject<NewsFeedCacheSetter> *)aNewsFeedCacheSetter;

#pragma mark Fetching news feeds

- (void)fetchNewsFeedForUsername:(NSString *)username;

@end
