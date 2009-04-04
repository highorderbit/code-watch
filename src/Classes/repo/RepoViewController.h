//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepoViewControllerDelegate.h"

@class RepoInfo;

@interface RepoViewController : UITableViewController
{
    IBOutlet NSObject<RepoViewControllerDelegate> * delegate;

    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;

    IBOutlet UILabel * repoNameLabel;
    IBOutlet UILabel * repoDescriptionLabel;
    IBOutlet UILabel * repoInfoLabel;
    IBOutlet UIImageView * repoImageView;
    IBOutlet UIButton * addToFavoritesButton;

    NSString * repoName;
    RepoInfo * repoInfo;
    NSDictionary * commits;
    NSMutableDictionary * avatars;
}

@property (nonatomic, retain) NSObject<RepoViewControllerDelegate> * delegate;

- (void)updateWithCommits:(NSDictionary *)someCommits
                  forRepo:(NSString *)aRepoName
                     info:(RepoInfo *)someRepoInfo;

- (void)updateWithAvatar:(UIImage *)avatar
         forEmailAddress:(NSString *)emailAddress;
         
- (IBAction)addToFavorites:(id)sender;

@end
