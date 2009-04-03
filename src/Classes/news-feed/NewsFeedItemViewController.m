//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedItemViewController.h"
#import "RssItem.h"
#import "RssItem+ParsingHelpers.h"
#import "RepoKey.h"
#import "UILabel+DrawingAdditions.h"
#import "RepoSelectorFactory.h"

static NSUInteger NUM_SECTIONS = 3;
enum Sections
{
    kDetailsSection,
    kActionSection,
    kGitHubEntitiesSection  // optional sections need to be at the end
};

static NSUInteger NUM_DETAILS_ROWS = 1;
enum DetailsSectionRows
{
    kDetailsRow
};

static NSUInteger NUM_GITHUB_ENTITIES_ROWS = 3;
enum kGitHubEntitiesSection
{
    kGoToAuthorRow,
    kGoToRepoOwnerRow,
    kGoToRepoRow
};

static NSUInteger NUM_ACTION_ROWS = 2;
enum ActionSectionRows
{
    kOpenInSafariRow,
    kEmailRow
};

@interface NewsFeedItemViewController (Private)

- (BOOL)haveGitHubUserInRssItem;
- (BOOL)haveGitHubRepoInRssItem;
- (void)updateDisplay;
- (void)setRssItem:(RssItem *)item;

@end

@implementation NewsFeedItemViewController

@synthesize delegate, repoSelectorFactory, rssItem;

- (void)dealloc
{
    [delegate release];
    [repoSelectorFactory release];
    [repoSelector release];
    [headerView release];
    [authorLabel release];
    [subjectLabel release];
    [avatarImageView release];
    [rssItem release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = headerView;

    self.navigationItem.title =
        NSLocalizedString(@"newsfeeditem.view.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateDisplay];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    NSInteger nsections = NUM_SECTIONS;
    if ([rssItem repoKey] == nil)
        --nsections;

    return nsections;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger nrows = 0;

    switch (section) {
        case kDetailsSection:
            nrows = NUM_DETAILS_ROWS;
            break;
        case kGitHubEntitiesSection:
            nrows = NUM_GITHUB_ENTITIES_ROWS;
            break;
        case kActionSection:
            nrows = NUM_ACTION_ROWS;
            break;
    }

    return nrows;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";

    UITableViewCell * cell =
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
        cell =
            [[[UITableViewCell alloc]
              initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]
             autorelease];

    switch (indexPath.section) {
        case kDetailsSection:
            cell.text = NSLocalizedString(@"newsfeeditem.details.label", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;

        case kGitHubEntitiesSection: {
            RepoKey * key = [rssItem repoKey];
            NSString * text = nil;

            switch (indexPath.row) {
                case kGoToAuthorRow:
                    text = rssItem.author;
                    break;
                case kGoToRepoOwnerRow:
                    text = key.username;
                    break;
                case kGoToRepoRow:
                    text = key.repoName;
                    break;
            }
            cell.text = text;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }

        case kActionSection: {
            NSString * text = nil;
            switch (indexPath.row) {
                case kOpenInSafariRow:
                    text = NSLocalizedString(@"newsfeeditem.safari.label", @"");
                    break;
                case kEmailRow:
                    text = NSLocalizedString(@"newsfeeditem.email.label", @"");
                    break;
            }

            cell.text = text;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

- (void)          tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kDetailsSection:
            [delegate userDidSelectDetails:rssItem];
            break;
        case kGitHubEntitiesSection: {
            RepoKey * key = [rssItem repoKey];

            switch (indexPath.row) {
                case kGoToAuthorRow:
                    [delegate userDidSelectUsername:rssItem.author];
                    break;
                case kGoToRepoOwnerRow:
                   [delegate userDidSelectUsername:key.username];
                   break;
                case kGoToRepoRow:
                    [delegate userDidSelectRepo:key.repoName
                                    ownedByUser:key.username];
                    break;
            }
            break;
        }
    }
}

#pragma mark Updating the display

- (void)updateWithRssItem:(RssItem *)item
{
    [self setRssItem:item];

    [self updateDisplay];
}

- (void)updateDisplay
{
    authorLabel.text = rssItem.author;

    if ([self haveGitHubUserInRssItem] && [self haveGitHubUserInRssItem])
        descriptionLabel.text = [[rssItem repoKey] description];
    else
        descriptionLabel.text = nil;

    CGFloat height = [subjectLabel heightForString:rssItem.subject];

    CGRect newFrame = subjectLabel.frame;
    newFrame.size.height = height;

    subjectLabel.frame = newFrame;
    subjectLabel.text = rssItem.subject;

    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = 85.0 + height;
    headerView.frame = headerFrame;

    self.tableView.tableHeaderView = headerView;

    [self.tableView reloadData];
}

#pragma mark Helper methods

- (BOOL)haveGitHubUserInRssItem
{
    return !![rssItem repoKey];
}

- (BOOL)haveGitHubRepoInRssItem
{
    return !![rssItem repoKey];
}

#pragma mark Accessors

- (void)setRssItem:(RssItem *)item
{
    RssItem * tmp = [item copy];
    [rssItem release];
    rssItem = tmp;
}

- (NSObject<RepoSelector> *)repoSelector
{
    if (!repoSelector)
        repoSelector =
            [repoSelectorFactory
            createRepoSelectorWithNavigationController:
            self.navigationController];

    return repoSelector;
}

@end
