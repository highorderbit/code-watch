//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RepoInfo;

@interface RepoViewController : UITableViewController
{
    RepoInfo * repoInfo;
    NSArray * commits;
}

- (void)updateWithCommits:(NSArray *)commits forRepo:(RepoInfo *)repoInfo;

@end
