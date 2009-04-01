//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController (Private)

- (void)refreshView;
- (void)updateNonZeroSearchResults;

@end

@implementation SearchViewController

@synthesize searchResults;

- (void)dealloc
{
    [tableView release];
    [searchBar release];
    [searchService release];
    [searchResults release];
    [nonZeroSearchResults release];
    [super dealloc];
}

- (id)initWithSearchService:(NSObject<SearchService> *)aSearchService
{
    if (self = [super init]) {
        searchService = [aSearchService retain];
        self.searchResults = [[NSMutableDictionary dictionary] retain];
        nonZeroSearchResults = [[NSMutableDictionary dictionary] retain];
    }

    return self;
}

#pragma mark UIViewController implementation

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)viewWillAppear:(BOOL)animated
{
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    NSInteger numNonZeroResultSets = [[nonZeroSearchResults allKeys] count];
    
    return numNonZeroResultSets > 0 ? numNonZeroResultSets : 1;
}

- (NSInteger)tableView:(UITableView *)aTableView
    numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows;
    
    NSArray * nonZeroSearchResultKeys = [nonZeroSearchResults allKeys];
    if ([nonZeroSearchResultKeys count] > 0) {
        NSString * key = [nonZeroSearchResultKeys objectAtIndex:section];
        numRows = [[nonZeroSearchResults objectForKey:key] count];
    } else
        numRows = 0;
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell * cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if (cell == nil)
        cell =
            [[[UITableViewCell alloc] initWithFrame:CGRectZero
            reuseIdentifier:CellIdentifier] autorelease];
            
    NSArray * nonZeroSearchResultKeys = [nonZeroSearchResults allKeys];
    NSString * key =
        [nonZeroSearchResultKeys objectAtIndex:indexPath.section];
    NSArray * results = [nonZeroSearchResults objectForKey:key];
    cell.text = [results objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)aTableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryNone;
}

- (NSString *)tableView:(UITableView *)aTableView
    titleForHeaderInSection:(NSInteger)section
{
    NSArray * nonZeroSearchResultKeys = [nonZeroSearchResults allKeys];

    return [nonZeroSearchResultKeys count] > 0 ?
        [nonZeroSearchResultKeys objectAtIndex:section] : nil;
}

#pragma mark UISearchBarDelegate implementation

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Searching service for '%@'...", searchText);
    [searchService searchForText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark SearchServiceDelegate implementation

- (void)processSearchResults:(NSDictionary *)results
    fromSearchService:(NSObject<SearchService> *)searchService
{
    NSLog(@"Received search results: %@", results);
    self.searchResults = results;
    [self refreshView];
}

#pragma mark Helper methods

- (void)refreshView
{
    [self updateNonZeroSearchResults];
    tableView.hidden = [[nonZeroSearchResults allKeys] count] == 0;
    [tableView reloadData];
}

- (void)updateNonZeroSearchResults
{
    for (NSString * category in [self.searchResults allKeys]) {
        NSArray * results = [self.searchResults objectForKey:category];
        if ([results count] == 0)
            [nonZeroSearchResults removeObjectForKey:category];
        else
            [nonZeroSearchResults setObject:results forKey:category];
    }
    
    NSLog(@"Non-zero search results: %@", nonZeroSearchResults);
}

@end
