//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubApiDelegate.h"

@class GitHubApiRequest;

@interface GitHubApi : NSObject
{
    id<GitHubApiDelegate> delegate;

    NSMutableDictionary * requests;
    NSMutableDictionary * connectionData;
}

#pragma mark Instantiation

- (id)initWithDelegate:(id<GitHubApiDelegate>)aDelegate;

#pragma mark Sending requests

- (void)sendRequest:(GitHubApiRequest *)request;

@end
