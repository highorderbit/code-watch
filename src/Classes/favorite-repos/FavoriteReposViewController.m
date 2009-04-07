//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteReposViewController.h"

@implementation FavoriteReposViewController

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [sortedRepoKeys release];
    [rightButton release];
    [super dealloc];
}

#pragma mark General view controller methods

- (void)viewDidLoad
{
    rightButton = [self.navigationItem.rightBarButtonItem retain];
    [self.navigationItem setLeftBarButtonItem:self.editButtonItem animated:NO];
}

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
    return [sortedRepoKeys count];
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
    
    cell.text = [[sortedRepoKeys objectAtIndex:indexPath.row] description];

    return cell;
}

- (void)tableView:(UITableView *)tv
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RepoKey * repoKey = [sortedRepoKeys objectAtIndex:indexPath.row];
        [delegate removedRepoKey:repoKey];
        
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
            withRowAnimation:UITableViewRowAnimationFade];
        
        [tv reloadData];
    }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate selectedRepoKey:[sortedRepoKeys objectAtIndex:indexPath.row]];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    else
        [self.navigationItem setRightBarButtonItem:rightButton animated:NO];
}

- (BOOL)tableView:(UITableView *)tv
    canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tv
    targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
    toProposedIndexPath:(NSIndexPath *)destinationIndexPath
{
    // Allow the proposed destination.
    return destinationIndexPath;
}

- (void)tableView:(UITableView *)tv
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
    toIndexPath:(NSIndexPath *)toIndexPath
{
    NSObject * objectToMove =
        [[sortedRepoKeys objectAtIndex:fromIndexPath.row] retain];
    [sortedRepoKeys removeObjectAtIndex:fromIndexPath.row];
    [sortedRepoKeys insertObject:objectToMove atIndex:toIndexPath.row];

    [delegate setRepoKeySortOrder:sortedRepoKeys];

    [objectToMove release];
}

#pragma mark Data updating methods

- (void)setRepoKeys:(NSArray *)repoKeys
{
    NSMutableArray * mutableCopy = [repoKeys mutableCopy];
    [sortedRepoKeys release];
    sortedRepoKeys = mutableCopy;
}

@end
