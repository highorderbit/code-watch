//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersViewController.h"

@implementation FavoriteUsersViewController

- (void)dealloc
{
    [delegate release];
    [sortedUsernames release];
    [super dealloc];
}

#pragma mark General view controller methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [delegate viewWillAppear];
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
            [[[UITableViewCell alloc] initWithFrame:CGRectZero
            reuseIdentifier:CellIdentifier] autorelease];
    
    cell.text = [sortedUsernames objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark Data updating methods

- (void)setUsernames:(NSArray *)usernames
{
    usernames = [usernames copy]; // TODO: sort
    [sortedUsernames release];
    sortedUsernames = usernames;
    
    [self.tableView reloadData];
}

@end
