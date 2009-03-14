//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UserViewController.h"

static const NSInteger NUM_SECTIONS = 3;

enum Section
{
    kUserDetailsSection,
    kRecentActivitySection,
    kRepoSection
};

@implementation UserViewController

- (void) dealloc
{
    [headerView release];
    [footerView release];
    
    [usernameLabel release];
    [nameLabel release];
    [emailLabel release];
    
    [user release];
    
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // TEMPORARY
    NSDictionary * someDetails =
        [[NSDictionary alloc] initWithObjectsAndKeys:
        @"Doug Kurth", @"name", @"Boulder, CO", @"location",
        @"doug@highorderbit.com", @"email", nil];
    NSArray * someRepos =
        [NSArray arrayWithObjects:@"Build Watch", @"Code Watch", nil];
    user =
        [[User alloc] initWithUsername:@"kurthd" details:someDetails
        repos:someRepos];
    // TEMPORARY

    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = headerView;
    
    // set Username, name, email
    if (user && user.details) {
        usernameLabel.text = user.username;
        
        NSString * name = [user.details objectForKey:@"name"];
        nameLabel.text = name ? name : @"";
        
        NSString * email = [user.details objectForKey:@"email"];
        emailLabel.text = email ? email : @"";        
    }
        
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = footerView;
}

#pragma mark Table view methods

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tv
{
    return NUM_SECTIONS;
}

- (NSInteger) tableView:(UITableView*)tv
    numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    switch (section) {
        case kUserDetailsSection:
            numRows = [user.details count];
            break;
        case kRecentActivitySection:
            numRows = 1;
            break;
        case kRepoSection:
            numRows = [user.repos count];
            break;
    }
    
    return numRows;
}

- (UITableViewCell*) tableView:(UITableView*)tv
    cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell* cell =
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =
            [[[UITableViewCell alloc] initWithFrame:CGRectZero
            reuseIdentifier:CellIdentifier]
            autorelease];
    }
    
    switch (indexPath.section) {
        case kUserDetailsSection:
            cell.text = [[user.details allValues] objectAtIndex:indexPath.row];
            break;
        case kRecentActivitySection:
            cell.text = @"Recent Activity";
            break;
        case kRepoSection:
            cell.text = [user.repos objectAtIndex:indexPath.row];
            break;
    }
    
    return cell;
}

- (NSString*) tableView:(UITableView *)tv
    titleForHeaderInSection:(NSInteger)section
{
    return section == kRepoSection ?
        NSLocalizedString(@"user.repo.header.label", @"") : nil;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*)tv
    accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
    return (indexPath.section == kRecentActivitySection ||
        indexPath.section == kRepoSection) ?
        UITableViewCellAccessoryDisclosureIndicator :
        UITableViewCellAccessoryNone;
}

#pragma mark User update methods

- (void)updateWithUser:(User *)aUser
{
    aUser = [aUser copy];
    [user release];
    user = aUser;
    
    [self.tableView reloadData];
}

@end
