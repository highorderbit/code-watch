//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubNewsFeedDelegate.h"
#import "WebServiceApiDelegate.h"

@class WebServiceApi, GitHubNewsFeedParser;

@interface GitHubNewsFeed : NSObject <WebServiceApiDelegate>
{
    id<GitHubNewsFeedDelegate> delegate;

    NSString * baseUrl;

    WebServiceApi * api;
    GitHubNewsFeedParser * parser;

    NSMutableDictionary * invocations;
}

@property (nonatomic, readonly) id<GitHubNewsFeedDelegate> delegate;
@property (nonatomic, copy, readonly) NSString * baseUrl;

#pragma mark Initialization

- (id)initWithBaseUrl:(NSString *)aBaseUrl
             delegate:(id<GitHubNewsFeedDelegate>)aDelegate;

#pragma mark Fetching activity

- (void)fetchNewsFeedForUsername:(NSString *)username;
- (void)fetchNewsFeedForUsername:(NSString *)username token:(NSString *)token;

@end
