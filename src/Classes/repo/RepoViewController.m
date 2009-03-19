//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoViewController.h"
#import "RepoActivityTableViewCell.h"
#import "RepoInfo.h"
#import "CommitInfo.h"

#import "NSDate+GitHubStringHelpers.h"

@interface RepoViewController (Private)
- (void)setCommits:(NSArray *)someCommits;
- (void)setRepoInfo:(RepoInfo *)repo;
@end

@implementation RepoViewController

- (void)dealloc
{
    [repoInfo release];
    [commits release];
    [super dealloc];
}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and
    // want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }

    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation
    // bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [RepoActivityTableViewCell reuseIdentifier];

    RepoActivityTableViewCell * cell = (RepoActivityTableViewCell *)
        [tv dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil)
        cell = [RepoActivityTableViewCell createCustomInstance];

    NSString * commitKey = [repoInfo.commitKeys objectAtIndex:indexPath.row];
    CommitInfo * info = [commits objectAtIndex:indexPath.row];

    NSString * message = [info.details objectForKey:@"message"];
    NSString * committer =
        [[info.details objectForKey:@"committer"] objectForKey:@"name"];
    NSDate * date = [NSDate dateWithGitHubString:
        [info.details objectForKey:@"committed_date"]];

    [cell setMessage:message];
    [cell setCommitter:committer];
    [cell setDate:date];
    [cell setCommitId:commitKey];

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)          tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController =
    //     [[AnotherViewController alloc]
    //      initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}

#pragma mark Resetting the displayed data

- (void)updateWithCommits:(NSArray *)someCommits forRepo:(RepoInfo *)repo
{
    [self setCommits:someCommits];
    [self setRepoInfo:repo];

    [self.tableView reloadData];
}

#pragma mark Accessors

- (void)setCommits:(NSArray *)someCommits
{
    NSArray * tmp = [someCommits copy];
    [commits release];
    commits = tmp;
}

- (void)setRepoInfo:(RepoInfo *)repo
{
    RepoInfo * tmp = [repo copy];
    [repoInfo release];
    repoInfo = tmp;
}

@end
