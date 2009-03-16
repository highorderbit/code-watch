//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "GitHubDelegate.h"

@class GitHub, GitHubServiceDelegate;

@interface GitHubService : NSObject <GitHubDelegate>
{
    id<GitHubServiceDelegate> delegate;

    IBOutlet GitHub * gitHub;
}

#pragma mark Instantiation

+ (id)service;
- (id)init;

#pragma mark Fetching user info from GitHub

- (void)fetchInfoForUsername:(NSString *)username;
- (void)fetchInfoForUsername:(NSString *)username token:(NSString *)token;

@end