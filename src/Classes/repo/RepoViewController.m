//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoViewController.h"
#import "RepoActivityTableViewCell.h"
#import "RepoInfo.h"
#import "CommitInfo.h"

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
    NSLog(@"Number of rows: %d.", commits.count);
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

    CommitInfo * info = [commits objectAtIndex:indexPath.row];
    NSString * message = [info.details objectForKey:@"message"];
    NSString * committer =
        [[info.details objectForKey:@"committer"] objectForKey:@"name"];

    [cell setMessage:message];
    [cell setCommitter:committer];
    [cell setDate:[NSDate date]];

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

- (void)updateWithCommits:(NSArray *)someCommits
{
    NSArray * tmp = [someCommits copy];
    [commits release];
    commits = tmp;

    NSLog(@"table view: '%@'.", self.tableView);
    [self.tableView reloadData];
}

@end
