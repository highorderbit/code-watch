//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CommitViewController.h"
#import "CommitInfo.h"
#import "UIColor+CodeWatchColors.h"
#import "UILabel+DrawingAdditions.h"
#import "UIAlertView+CreationHelpers.h"
#import "UIImage+AvatarHelpers.h"
#import "NSDate+StringHelpers.h"
#import "NSDate+GitHubStringHelpers.h"
#import "HOTableViewCell.h"
#import "UIColor+CodeWatchColors.h"

static const NSUInteger NUM_SECTIONS = 2;
enum
{
    kDiffSection,
    kActionSection
} kSections;

static const NSUInteger NUM_DIFF_ROWS = 3;
enum
{
    kAddedRow,
    kRemovedRow,
    kModifiedRow
} kDiffRows;

static const NSUInteger NUM_ACTION_ROWS = 2;
enum
{
    kOpenInSafariRow,
    kEmailRow
};

@interface CommitViewController (Private)

- (void)updateDisplay;

- (void)openCommitInSafari;
- (void)emailCommit;

- (void)formatDiffCell:(UITableViewCell *)cell
         withChangeset:(NSArray *)changes
  singularFormatString:(NSString *)singularFormatString
    pluralFormatString:(NSString *)pluralFormatString;

- (void)setRepoName:(NSString *)repo;
- (void)setCommitInfo:(CommitInfo *)info;
- (void)setAvatar:(UIImage *)anAvatar;

@end

@implementation CommitViewController

@synthesize delegate, repoName, commitInfo, avatar;

- (void)dealloc
{
    [delegate release];

    [headerView release];

    [nameLabel release];
    [emailButton release];
    [timestampLabel release];
    [messageLabel release];
    [avatarImageView release];

    [repoName release];
    [commitInfo release];
    [avatar release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    headerView.backgroundColor = [UIColor codeWatchBackgroundColor];
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.backgroundColor = [UIColor codeWatchBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // this is a hack to fix an occasional bug exhibited on the device where the
    // selected cell isn't deselected
    [self.tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return NUM_SECTIONS;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger nrows = 0;

    switch (section) {
        case kDiffSection:
            nrows = NUM_DIFF_ROWS;
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
    static NSString * CellIdentifier = @"CommitViewTableViewCell";

    UITableViewCell * cell =
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
        cell =
            [[[HOTableViewCell alloc]
            initWithFrame:CGRectZero reuseIdentifier:CellIdentifier
            tableViewStyle:UITableViewStyleGrouped]
            autorelease];

    switch (indexPath.section) {
        case kDiffSection: {
            NSString * pluralFormatString, * singularFormatString;
            NSArray * changeset;
            switch (indexPath.row) {
                case kAddedRow:
                    pluralFormatString =
                        NSLocalizedString(@"commit.added.plural.formatstring",
                            @"");
                    singularFormatString =
                        NSLocalizedString(@"commit.added.singular.formatstring",
                            @"");
                    changeset = [commitInfo.changesets objectForKey:@"added"];
                    break;
                case kRemovedRow:
                    pluralFormatString =
                        NSLocalizedString(@"commit.removed.plural.formatstring",
                            @"");
                    singularFormatString =
                        NSLocalizedString(
                            @"commit.removed.singular.formatstring", @"");
                    changeset = [commitInfo.changesets objectForKey:@"removed"];
                    break;
                case kModifiedRow:
                    pluralFormatString =
                        NSLocalizedString(
                            @"commit.modified.plural.formatstring",
                            @"");
                    singularFormatString =
                        NSLocalizedString(
                            @"commit.modified.singular.formatstring",
                            @"");
                    changeset =
                        [commitInfo.changesets objectForKey:@"modified"];
                    break;
            }
            [self formatDiffCell:cell withChangeset:changeset
                singularFormatString:singularFormatString
                pluralFormatString:pluralFormatString];
            break;
        }

        case kActionSection:
            switch (indexPath.row) {
                case kOpenInSafariRow:
                    cell.text = NSLocalizedString(@"commit.safari.label", @"");
                    break;
                case kEmailRow:
                    cell.text = NSLocalizedString(@"commit.email.label", @"");
                    break;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textColor = [UIColor blackColor];
            break;
    }

    return cell;
}

- (NSIndexPath *) tableView:(UITableView *)tv
   willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kDiffSection) {
        NSArray * changeset = nil;
        switch (indexPath.row) {
            case kAddedRow:
                changeset = [commitInfo.changesets objectForKey:@"added"];
                break;
            case kRemovedRow:
                changeset = [commitInfo.changesets objectForKey:@"removed"];
                break;
            case kModifiedRow:
                changeset = [commitInfo.changesets objectForKey:@"modified"];
                break;
        }

        return changeset.count == 0 ? nil : indexPath;
    }

    return indexPath;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kDiffSection) {
        NSArray * changeset = nil;
        ChangesetType changesetType;

        switch (indexPath.row) {
            case kAddedRow:
                changeset = [commitInfo.changesets objectForKey:@"added"];
                changesetType = kChangesetTypeAdded;
                break;
            case kRemovedRow:
                changeset = [commitInfo.changesets objectForKey:@"removed"];
                changesetType = kChangesetTypeRemoved;
                break;
            case kModifiedRow:
                changeset = [commitInfo.changesets objectForKey:@"modified"];
                changesetType = kChangesetTypeModified;
                break;
        }

        [delegate userDidSelectChangeset:changeset ofType:changesetType];
    } else if (indexPath.section == kActionSection) {
        switch (indexPath.row) {
            case kOpenInSafariRow:
                [self openCommitInSafari];
                break;
            case kEmailRow:
                [self emailCommit];
                break;
        }
    }
}

#pragma mark Commit actions

- (void)openCommitInSafari
{
    NSURL * url =
        [NSURL URLWithString:[commitInfo.details objectForKey:@"url"]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)emailCommit
{
    NSString * committer = 
        [[commitInfo.details objectForKey:@"committer"] objectForKey:@"name"];
    NSString * committerEmail = 
        [[commitInfo.details objectForKey:@"committer"] objectForKey:@"email"];
    NSString * message = [commitInfo.details objectForKey:@"message"];
    NSString * commitLink = [commitInfo.details objectForKey:@"url"];

    NSArray * added = [commitInfo.changesets objectForKey:@"added"];
    NSArray * removed = [commitInfo.changesets objectForKey:@"removed"];
    NSArray * modified = [commitInfo.changesets objectForKey:@"modified"];

    NSMutableArray * files =
        [NSMutableArray
        arrayWithCapacity:added.count + removed.count + modified.count];

    for (NSDictionary * d in added)
        [files addObject:[d objectForKey:@"filename"]];
    for (NSDictionary * d in removed)
        [files addObject:[d objectForKey:@"filename"]];
    for (NSDictionary * d in modified)
        [files addObject:[d objectForKey:@"filename"]];

    NSMutableString * filelist = [NSMutableString string];
    for (NSString * filename in files)
        [filelist appendFormat:@"%@\n", filename];

    NSString * subject = [NSString stringWithFormat:
        NSLocalizedString(@"commit.email.subject.formatstring", @""), repoName,
        committer, message];

    NSMutableString * body = [NSMutableString string];

    [body appendFormat:@"%@: %@\n",
        NSLocalizedString(@"commit.email.repository", @""), repoName];
    [body appendFormat:@"%@: %@ (%@)\n",
        NSLocalizedString(@"commit.email.committer", @""), committer,
        committerEmail];
    [body appendFormat:@"\n%@:\n%@\n",
        NSLocalizedString(@"commit.email.commitmessage", @""), message];
    [body appendFormat:@"\n%@:\n%@\n",
        NSLocalizedString(@"commit.email.changeset", @""),
        filelist.length == 0 ? @"None\n" : filelist];
    [body appendFormat:@"%@:\n%@",
        NSLocalizedString(@"commit.email.link", @""), commitLink];

    NSString * urlString =
        [[NSString stringWithFormat:NSLocalizedString(@"commit.email.url", @""),
         subject, body]
         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
}

#pragma mark UI helpers

- (void)formatDiffCell:(UITableViewCell *)cell
         withChangeset:(NSArray *)changes
  singularFormatString:(NSString *)singularFormatString
    pluralFormatString:(NSString *)pluralFormatString
{
    NSString * text =
        changes.count == 1 ?
        [NSString stringWithFormat:singularFormatString, changes.count] :
        [NSString stringWithFormat:pluralFormatString, changes.count];

    UIColor * textColor = changes.count == 0 ?
        [UIColor codeWatchGrayColor] : [UIColor blackColor];

    UITableViewCellAccessoryType accessoryType =
        changes.count == 0 ?
        UITableViewCellAccessoryNone :
        UITableViewCellAccessoryDisclosureIndicator;

    UITableViewCellSelectionStyle selectionStyle =
        changes.count == 0 ?
        UITableViewCellSelectionStyleNone :
        UITableViewCellSelectionStyleBlue;

    cell.text = text;
    cell.textColor = textColor;
    cell.accessoryType = accessoryType;
    cell.selectionStyle = selectionStyle;
}

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:self.tableView.frame animated:NO];
}

- (IBAction)sendEmail:(id)sender
{
    NSString * to = [emailButton titleForState:UIControlStateNormal];
    NSString * urlString =
        [[NSString stringWithFormat:@"mailto:%@", to]
        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
}

#pragma mark Updating the view with new data

- (void)updateWithCommitInfo:(CommitInfo *)info
                     forRepo:(NSString *)repo
{
    [self setRepoName:repo];
    [self setCommitInfo:info];

    [self updateDisplay];

}

- (void)updateWithAvatar:(UIImage *)anAvatar
{
    [self setAvatar:anAvatar ? anAvatar : [UIImage imageUnavailableImage]];

    [self updateDisplay];
}

- (void)updateDisplay
{
    avatarImageView.image = avatar;

    NSString * committerName =
        [[commitInfo.details objectForKey:@"committer"] objectForKey:@"name"];
    NSString * committerEmail =
        [[commitInfo.details objectForKey:@"committer"] objectForKey:@"email"];
    NSString * message = [commitInfo.details objectForKey:@"message"];

    NSString * timestampstring =
        [commitInfo.details objectForKey:@"committed_date"];
    NSDate * timestamp = timestampstring ?
        [NSDate dateWithGitHubString:timestampstring] : nil;

    nameLabel.text = committerName;
    [emailButton setTitle:committerEmail forState:UIControlStateNormal];
    [emailButton setTitle:committerEmail forState:UIControlStateHighlighted];
    timestampLabel.text = [timestamp shortDateAndTimeDescription];

    CGFloat height = [messageLabel heightForString:message];

    CGRect newFrame = messageLabel.frame;
    newFrame.size.height = height;

    messageLabel.frame = newFrame;
    messageLabel.text = message;

    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = 89.0 + height;
    headerView.frame = headerFrame;

    self.tableView.tableHeaderView = headerView;

    [self.tableView reloadData];
}

#pragma mark Accessors

- (void)setRepoName:(NSString *)repo
{
    NSString * tmp = [repo copy];
    [repoName release];
    repoName = tmp;
}

- (void)setCommitInfo:(CommitInfo *)info
{
    CommitInfo * tmp = [info copy];
    [commitInfo release];
    commitInfo = tmp;
}

- (void)setAvatar:(UIImage *)anAvatar
{
    UIImage * tmp = [anAvatar retain];
    [avatar release];
    avatar = tmp;
}

@end
