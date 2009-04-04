//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoViewController.h"
#import "RepoActivityTableViewCell.h"
#import "RepoInfo.h"
#import "CommitInfo.h"

#import "NSDate+GitHubStringHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface RepoViewController (Private)
- (void)updateHeaderView;
- (void)setRepoName:(NSString *)name;
- (void)setRepoInfo:(RepoInfo *)repo;
- (void)setCommits:(NSDictionary *)someCommits;
- (void)setAvatars:(NSMutableDictionary *)someAvatars;
@end

@implementation RepoViewController

@synthesize delegate;

- (void)dealloc
{
    [delegate release];

    [headerView release];
    [footerView release];

    [repoNameLabel release];
    [repoDescriptionLabel release];
    [repoInfoLabel release];
    [repoImageView release];
    [addToFavoritesButton release];

    [repoName release];
    [repoInfo release];
    [commits release];
    [avatars release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setAvatars:[[NSMutableDictionary alloc] init]];

    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
    
    [addToFavoritesButton setTitleColor:[UIColor grayColor]
        forState:UIControlStateDisabled];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    BOOL private = [[repoInfo.details objectForKey:@"private"] boolValue];
    repoImageView.image =
        private ?
        [UIImage imageNamed:@"private-icon.png"] :
        [UIImage imageNamed:@"public-icon.png"];

    [self updateHeaderView];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    return commits.count;
}

- (NSString*) tableView:(UITableView *)tv
    titleForHeaderInSection:(NSInteger)section
{
    return @"Commits";
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [RepoActivityTableViewCell reuseIdentifier];

    RepoActivityTableViewCell * cell = (RepoActivityTableViewCell *)
        [tv dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil)
        cell = [RepoActivityTableViewCell createCustomInstance];

    NSString * commitKey = [repoInfo.commitKeys objectAtIndex:indexPath.row];
    CommitInfo * info = [commits objectForKey:commitKey];

    NSString * message = [info.details objectForKey:@"message"];
    NSString * committer =
        [[info.details objectForKey:@"committer"] objectForKey:@"name"];
    NSString * email =
        [[info.details objectForKey:@"committer"] objectForKey:@"email"];
    NSDate * date = [NSDate dateWithGitHubString:
        [info.details objectForKey:@"committed_date"]];
    UIImage * avatar = [avatars objectForKey:email];

    [cell setMessage:message];
    [cell setCommitter:committer];
    [cell setDate:date];
    [cell setAvatar:avatar];

    return cell;
}

- (void)          tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * commitKey = [repoInfo.commitKeys objectAtIndex:indexPath.row];
    [delegate userDidSelectCommit:commitKey];
}

#pragma mark Resetting the displayed data

- (void)updateWithCommits:(NSDictionary *)someCommits
                  forRepo:(NSString *)aRepoName
                     info:(RepoInfo *)someRepoInfo
{
    [self setCommits:someCommits];
    [self setRepoName:aRepoName];
    [self setRepoInfo:someRepoInfo];

    self.navigationItem.title = repoName;
    [self updateHeaderView];
    [self.tableView reloadData];
}

- (void)updateWithAvatar:(UIImage *)avatar
         forEmailAddress:(NSString *)emailAddress
{
    [avatars setObject:avatar forKey:emailAddress];

    [self.tableView reloadData];
}

#pragma mark Updating the views

- (void)updateHeaderView
{
    repoNameLabel.text = repoName;

    NSString * repoDesc = [repoInfo.details objectForKey:@"description"];
    CGFloat height = [repoDescriptionLabel heightForString:repoDesc];

    CGRect labelFrame = repoDescriptionLabel.frame;
    labelFrame.size.height = height;
    repoDescriptionLabel.frame = labelFrame;
    repoDescriptionLabel.text = repoDesc;

    CGRect headerViewFrame = headerView.frame;
    headerViewFrame.size.height = 357.0 + height;
    headerView.frame = headerViewFrame;

    // force the header view to redraw
    self.tableView.tableHeaderView = headerView;

    NSInteger nwatchers =
        [[repoInfo.details objectForKey:@"watchers"] integerValue];
    NSInteger nforks =
        [[repoInfo.details objectForKey:@"forks"] integerValue];

    NSString * watchersFormatString = nwatchers == 1 ?
        NSLocalizedString(@"repo.watchers.label.formatstring.singular", @"") :
        NSLocalizedString(@"repo.watchers.label.formatstring.plural", @"");
    NSString * watchersLabel =
        [NSString stringWithFormat:watchersFormatString, nwatchers];

    NSString * forksFormatString = nforks == 1 ?
        NSLocalizedString(@"repo.forks.label.formatstring.singular", @"") :
        NSLocalizedString(@"repo.forks.label.formatstring.plural", @"");
    NSString * forksLabel =
        [NSString stringWithFormat:forksFormatString, nforks];

    repoInfoLabel.text =
        [NSString stringWithFormat:@"%@ / %@", watchersLabel, forksLabel];
}

#pragma mark Add to favorites

- (IBAction)addToFavorites:(id)sender
{
    NSLog(@"Adding repo '%@' to favorites...", repoName);
//    [favoriteRepoStateSetter addFavoriteUser:username];
    addToFavoritesButton.enabled = NO;
}

#pragma mark Accessors

- (void)setRepoName:(NSString *)name
{
    NSString * tmp = [name copy];
    [repoName release];
    repoName = tmp;
}

- (void)setRepoInfo:(RepoInfo *)repo
{
    RepoInfo * tmp = [repo copy];
    [repoInfo release];
    repoInfo = tmp;
}

- (void)setCommits:(NSDictionary *)someCommits
{
    NSDictionary * tmp = [someCommits copy];
    [commits release];
    commits = tmp;
}

- (void)setAvatars:(NSMutableDictionary *)someAvatars
{
    NSMutableDictionary * tmp = [someAvatars mutableCopy];
    [avatars release];
    avatars = tmp;
}

@end
