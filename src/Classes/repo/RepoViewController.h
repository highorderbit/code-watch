//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RepoInfo;

@interface RepoViewController : UITableViewController
{
    RepoInfo * repoInfo;
}

- (void)updateWithRepoInfo:(RepoInfo *)info;

@end
