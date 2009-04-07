//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepoViewControllerDelegate.h"
#import "FavoriteReposStateSetter.h"
#import "FavoriteReposStateReader.h"
#import "RepoKey.h"

@class RepoInfo;

@interface RepoViewController : UITableViewController
{
    IBOutlet NSObject<RepoViewControllerDelegate> * delegate;
    IBOutlet NSObject<FavoriteReposStateSetter> * favoriteReposStateSetter;
    IBOutlet NSObject<FavoriteReposStateReader> * favoriteReposStateReader;
    
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
@property (nonatomic, retain)
    NSObject<FavoriteReposStateSetter> * favoriteReposStateSetter;
@property (nonatomic, retain)
    NSObject<FavoriteReposStateReader> * favoriteReposStateReader;
@property (readonly) RepoKey * repoKey;

- (void)updateWithCommits:(NSDictionary *)someCommits
                  forRepo:(NSString *)aRepoName
                     info:(RepoInfo *)someRepoInfo;

- (void)updateWithAvatar:(UIImage *)avatar
         forEmailAddress:(NSString *)emailAddress;
         
- (IBAction)addToFavorites:(id)sender;

- (void)scrollToTop;

@end
