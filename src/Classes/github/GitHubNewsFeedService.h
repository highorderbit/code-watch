//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubNewsFeedServiceDelegate.h"
#import "GitHubNewsFeedDelegate.h"

#import "LogInStateReader.h"
#import "ConfigReader.h"

@class GitHubNewsFeed;

@interface GitHubNewsFeedService : NSObject <GitHubNewsFeedDelegate>
{
    id<GitHubNewsFeedServiceDelegate> delegate;

    NSObject<LogInStateReader> * logInStateReader;

    GitHubNewsFeed * newsFeed;
}

#pragma mark Initialization

- (id)initWithConfigReader:(NSObject<ConfigReader> *)aConfigReader
          logInStateReader:(NSObject<LogInStateReader> *)aLogInStateReader
                  delegate:(id<GitHubNewsFeedServiceDelegate>)aDelegate;

#pragma mark Fetching news feeds

- (void)fetchNewsFeedForUsername:(NSString *)username;

@end
