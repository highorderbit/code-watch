//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitCache.h"
#import "CommitSelector.h"
#import "GitHubServiceFactory.h"

@interface CommitSelectorFactory : NSObject
{
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    IBOutlet CommitCache * commitCache;
}

- (NSObject<CommitSelector> *)
    createCommitSelectorWithNavigationController:
    (UINavigationController *)navigationController;

@end
