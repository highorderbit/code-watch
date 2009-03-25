//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CommitViewController.h"
#import "CommitInfo.h"

static const NSUInteger NUM_SECTIONS = 2;
enum
{
    kDiffSection,
    kActionSection
} kSections;

static const NSUInteger NUM_DIFF_ROWS = 3;
enum
{
    kRemovedRow,
    kAddedRow,
    kChangedRow
} kDiffRows;

static const NSUInteger NUM_ACTION_ROWS = 2;
enum
{
    kSafariRow,
    kEmailRow
};

@interface CommitViewController (Private)
- (void)setCommitInfo:(CommitInfo *)info;
@end

@implementation CommitViewController

@synthesize commitInfo;

- (void)dealloc
{
    [headerView release];

    [avatarImageView release];
    [nameLabel release];
    [emailLabel release];
    [messageLabel release];

    [commitInfo release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = headerView;
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
*/

/*
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
*/

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
    static NSString * CellIdentifier = @"Cell";

    UITableViewCell * cell =
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
        cell =
            [[[UITableViewCell alloc]
              initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]
             autorelease];

    switch (indexPath.section) {
        case kDiffSection:
            switch (indexPath.row) {
                case kAddedRow:
                    cell.text = @"Added";
                    break;
                case kRemovedRow:
                    cell.text = @"Removed";
                    break;
                case kChangedRow:
                    cell.text = @"Modified";
                    break;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;

        case kActionSection:
            switch (indexPath.row) {
                case kSafariRow:
                    cell.text = @"Open in Safari";
                    break;
                case kEmailRow:
                    cell.text = @"Email";
                    break;
            }
            break;
    }

    return cell;
}
- (NSIndexPath *) tableView:(UITableView *)tv
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

/*
// Override to support conditional editing of the table view.
- (BOOL)        tableView:(UITableView *)tv
    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)     tableView:(UITableView *)tv
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView
         deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
               withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
        // array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)     tableView:(UITableView *)tv
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)        tableView:(UITableView *)tv
    canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark Updating the view with new data

- (void)updateWithCommitInfo:(CommitInfo *)info
{
    [self setCommitInfo:info];

    NSString * committerName =
        [[info.details objectForKey:@"committer"] objectForKey:@"name"];
    NSString * committerEmail =
        [[info.details objectForKey:@"committer"] objectForKey:@"email"];
    NSString * message = [info.details objectForKey:@"message"];

    nameLabel.text = committerName;
    emailLabel.text = committerEmail;

    CGSize maximumLabelSize = CGSizeMake(298.0, 9999.0);

    UIFont * font = messageLabel.font;
    CGSize size = [message sizeWithFont:font constrainedToSize:maximumLabelSize
        lineBreakMode:UILineBreakModeWordWrap];

    CGRect newFrame = messageLabel.frame;
    newFrame.size = size;

    messageLabel.frame = newFrame;
    messageLabel.text = message;

    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = 85.0 + size.height;
    headerView.frame = headerFrame;

    self.tableView.tableHeaderView = headerView;

    [self.tableView reloadData];
}

#pragma mark Accessors

- (void)setCommitInfo:(CommitInfo *)info
{
    CommitInfo * tmp = [info copy];
    [commitInfo release];
    commitInfo = tmp;
}

@end
