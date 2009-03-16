//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubDelegate.h"
#import "GitHubApiDelegate.h"
#import "GitHubApiParser.h"

@class GitHubApi, GitHubApiRequest;

@interface GitHub : NSObject <GitHubApiDelegate>
{
    id<GitHubDelegate> delegate;

    NSURL * baseUrl;
    GitHubApiFormat apiFormat;

    GitHubApi * api;
    GitHubApiParser * parser;

    NSMutableDictionary * requests;
}

@property (nonatomic, readonly) id<GitHubDelegate> delegate;
@property (nonatomic, readonly) NSURL * baseUrl;
@property (nonatomic, readonly, assign) GitHubApiFormat apiFormat;

#pragma mark Initialization

- (id)initWithBaseUrl:(NSURL *)url
               format:(GitHubApiFormat)format
             delegate:(id<GitHubDelegate>)aDelegate;

#pragma mark Working with repositories

- (void)fetchInfoForUsername:(NSString *)username;

@end
