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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [delegate viewWillAppear];
    [self setEditing:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate selectedUsername:[sortedUsernames objectAtIndex:indexPath.row]];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark Data updating methods

- (void)setUsernames:(NSArray *)usernames
{
    NSMutableArray * mutableCopy = [usernames mutableCopy];
    [sortedUsernames release];
    sortedUsernames = mutableCopy;
}

@end
