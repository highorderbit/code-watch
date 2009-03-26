//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoViewController.h"
#import "RepoActivityTableViewCell.h"
#import "RepoInfo.h"
#import "CommitInfo.h"

#import "NSDate+GitHubStringHelpers.h"

@interface RepoViewController (Private)
- (void)setRepoName:(NSString *)name;
- (void)setRepoInfo:(RepoInfo *)repo;
- (void)setCommits:(NSDictionary *)someCommits;
@end

@implementation RepoViewController

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [headerView release];
    [repoNameLabel release];
    [repoDescriptionLabel release];
    [repoInfoLabel release];
    [repoImageView release];
    [repoName release];
    [repoInfo release];
    [commits release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableHeaderView = headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    repoNameLabel.text = repoName;
    repoDescriptionLabel.text = [repoInfo.details objectForKey:@"description"];

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
    NSDate * date = [NSDate dateWithGitHubString:
        [info.details objectForKey:@"committed_date"]];

    [cell setMessage:message];
    [cell setCommitter:committer];
    [cell setDate:date];

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
    [self.tableView reloadData];
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

@end
