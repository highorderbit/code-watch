//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoInfo.h"

@protocol RepoCacheReader

@property (readonly, copy) NSDictionary * allRepos;
@property (readonly, copy) NSDictionary * allPrimaryUserRepos;

- (RepoInfo *)primaryUserRepoWithName:(NSString *)repoName;
- (RepoInfo *)repoWithUsername:(NSString *)username
    repoName:(NSString *)repoName;

@end
