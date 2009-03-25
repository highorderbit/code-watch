//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RepoInfo;

@interface RepoViewController : UITableViewController
{
    IBOutlet UIView * headerView;

    IBOutlet UILabel * repoNameLabel;
    IBOutlet UILabel * repoDescriptionLabel;
    IBOutlet UILabel * repoInfoLabel;
    IBOutlet UIImageView * repoImageView;

    NSString * repoName;
    RepoInfo * repoInfo;
    NSDictionary * commits;
}

- (void)updateWithCommits:(NSDictionary *)someCommits
                  forRepo:(NSString *)aRepoName
                     info:(RepoInfo *)someRepoInfo;

@end
