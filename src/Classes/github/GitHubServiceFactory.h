//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubService.h"

@interface GitHubServiceFactory : NSObject
{
    IBOutlet NSObject<ConfigReader> * configReader;
    IBOutlet LogInState * logInState;
    IBOutlet UserCache * userCache;
    IBOutlet RepoCache * repoCache;
    IBOutlet CommitCache * commitCache;
}

- (GitHubService *)createGitHubService;

@end
