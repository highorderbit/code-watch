//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubDelegate.h"
#import "GitHubApiFormat.h"

#import "WebServiceApiDelegate.h"

@class WebServiceApi, GitHubApiParser;

@interface GitHub : NSObject <WebServiceApiDelegate>
{
    id<GitHubDelegate> delegate;

    NSURL * baseUrl;
    GitHubApiFormat apiFormat;

    WebServiceApi * api;
    GitHubApiParser * parser;

    NSMutableDictionary * requests;
}

@property (nonatomic, readonly) id<GitHubDelegate> delegate;
@property (nonatomic, readonly) NSURL * baseUrl;
@property (nonatomic, readonly) GitHubApiFormat apiFormat;

#pragma mark Initialization

- (id)initWithBaseUrl:(NSURL *)url
               format:(GitHubApiFormat)format
             delegate:(id<GitHubDelegate>)aDelegate;

#pragma mark Fetching user info from GitHub

- (void)fetchInfoForUsername:(NSString *)username token:(NSString *)token;

#pragma mark Fetching repository information

- (void)fetchInfoForRepo:(NSString *)repo
                username:(NSString *)username
                   token:(NSString *)token;

#pragma mark Fetching commit information

- (void)fetchInfoForCommit:(NSString *)commitKey
                      repo:(NSString *)repo
                  username:(NSString *)username
                     token:(NSString *)token;

#pragma mark Fetching followers

- (void)fetchFollowingForUsername:(NSString *)username;

#pragma mark Searching GitHub

- (void)search:(NSString *)searchString;

@end
