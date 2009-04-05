//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitSelector.h"

@class CommitCache, AvatarCache;
@class GitHubServiceFactory, GravatarServiceFactory;

@interface CommitSelectorFactory : NSObject
{
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    IBOutlet GravatarServiceFactory * gravatarServiceFactory;

    IBOutlet CommitCache * commitCache;
    IBOutlet AvatarCache * avatarCache;
}

- (NSObject<CommitSelector> *)
    createCommitSelectorWithNavigationController:
    (UINavigationController *)navigationController;

@end
