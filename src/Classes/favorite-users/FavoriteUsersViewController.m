//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersViewController.h"
#import "HOTableViewCell.h"

@implementation FavoriteUsersViewController

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [sortedUsernames release];
    [super dealloc];
}

#pragma mark General view controller methods

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // this is a hack to fix an occasional bug exhibited on the device where the
    // selected cell isn't deselected
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // fixes a bug where the scroll indicator region is incorrectly set after
    // the logout action sheet is shown
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [sortedUsernames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell * cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if (cell == nil)
        cell =
            [[[HOTableViewCell alloc] initWithFrame:CGRectZero
            reuseIdentifier:CellIdentifier] autorelease];
    
    cell.text = [sortedUsernames objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate selectedUsername:[sortedUsernames objectAtIndex:indexPath.row]];
}

#pragma mark Data updating methods

- (void)setUsernames:(NSArray *)usernames
{
    NSMutableArray * mutableCopy = [usernames mutableCopy];
    [sortedUsernames release];
    sortedUsernames = mutableCopy;
    
    [self.tableView reloadData];
}

@end
