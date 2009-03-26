//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "ChangesetViewController.h"

@interface ChangesetViewController (Private)
- (void)setChangeset:(NSArray *)aChangeset;
@end

@implementation ChangesetViewController

@synthesize delegate, changeset;

- (void)dealloc
{
    [delegate release];

    [changeset release];

    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    return changeset.count;
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

    NSDictionary * details = [changeset objectAtIndex:indexPath.row];
    cell.text = [[details objectForKey:@"filename"] lastPathComponent];

    if ([details objectForKey:@"diff"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * diff = [changeset objectAtIndex:indexPath.row];
    return [diff objectForKey:@"diff"] ? indexPath : nil;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate userDidSelectDiff:[changeset objectAtIndex:indexPath.row]];
}

#pragma mark Loading new data

- (void)updateWithChangeset:(NSArray *)aChangeset
{
    [self setChangeset:aChangeset];

    [self.tableView reloadData];
}

#pragma mark Accessors

- (void)setChangeset:(NSArray *)aChangeset
{
    NSArray * tmp = [aChangeset copy];
    [changeset release];
    changeset = tmp;
}

@end
