//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubDelegate.h"
#import "GitHubApiFormat.h"
#import "GitHubApiVersion.h"

#import "GitHubApiDelegate.h"

@class GitHubApi, GitHubApiRequest, GitHubApiParser;

@interface GitHub : NSObject <GitHubApiDelegate>
{
    id<GitHubDelegate> delegate;

    NSURL * baseUrl;
    GitHubApiFormat apiFormat;
    GitHubApiVersion apiVersion;

    GitHubApi * api;
    GitHubApiParser * parser;

    NSMutableDictionary * requests;
}

@property (nonatomic, readonly) id<GitHubDelegate> delegate;
@property (nonatomic, readonly) NSURL * baseUrl;
@property (nonatomic, readonly) GitHubApiFormat apiFormat;
@property (nonatomic, readonly) GitHubApiVersion apiVersion;

#pragma mark Initialization

- (id)initWithBaseUrl:(NSURL *)url
               format:(GitHubApiFormat)format
              version:(GitHubApiVersion)version
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

@end
