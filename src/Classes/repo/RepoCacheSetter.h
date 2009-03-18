//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RepoCacheSetter

- (void)setPrimaryUserRepo:(RepoInfo *)repo forRepoName:(NSString *)repoName;
- (void)removePrimaryUserRepoForName:(NSString *)repoName;

- (void)addRecentlyViewedRepo:(RepoInfo *)repo withRepoName:(NSString *)repoName
    username:(NSString *)username;

@end
