//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController (Private)

- (void)refreshView;
- (void)updateNonZeroSearchResults;

+ (NSArray *)filterResults:(NSArray *)results byText:(NSString *)text;

@end

@implementation SearchViewController

- (void)dealloc
{
    [tableView release];
    [searchBar release];
    [searchServices release];
    [searchResults release];
    [nonZeroSearchResults release];
    [lastSearchedText release];
    [super dealloc];
}

- (id)initWithSearchServices:(NSDictionary *)someSearchServices
{
    if (self = [super init]) {
        searchServices = [someSearchServices retain];
        searchResults = [[NSMutableDictionary dictionary] retain];
        for (NSObject * service in [someSearchServices allKeys])
            [searchResults setObject:[NSArray array] forKey:service];
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
        NSObject * service = [nonZeroSearchResultKeys objectAtIndex:section];
        numRows = [[nonZeroSearchResults objectForKey:service] count];
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
    NSObject * service =
        [nonZeroSearchResultKeys objectAtIndex:indexPath.section];
    NSArray * results = [nonZeroSearchResults objectForKey:service];
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
    NSString * title;
    
    NSArray * nonZeroSearchResultKeys = [nonZeroSearchResults allKeys];
    if ([nonZeroSearchResultKeys count] > 0) {
        NSObject * service = [nonZeroSearchResultKeys objectAtIndex:section];
        title = [searchServices objectForKey:service];
    } else
        title = nil;
    
    return title;
}

#pragma mark UISearchBarDelegate implementation

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Searching all services for '%@'...", searchText);

    [lastSearchedText release];
    lastSearchedText = [searchText copy];
    for(NSObject<SearchService> * service in [searchServices allKeys]) {
        // modify the existing search results
        NSArray * filteredResults =
            [[self class] filterResults:[searchResults objectForKey:service]
            byText:searchText];
        [searchResults setObject:filteredResults forKey:service];
        [service searchForText:searchText];
    }
    
    [self refreshView];
}

#pragma mark SearchServiceDelegate implementation

- (void)processSearchResults:(NSArray *)results
    fromSearchService:(NSObject<SearchService> *)searchService
{
    NSLog(@"Received search results: %@", results);
    NSArray * filteredResults =
        [[self class] filterResults:results byText:lastSearchedText];
    NSLog(@"Received filtered search results: %@", filteredResults);
    [searchResults setObject:filteredResults forKey:searchService];
    
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
    for (NSObject * service in [searchResults allKeys]) {
        NSArray * results = [searchResults objectForKey:service];
        if ([results count] == 0)
            [nonZeroSearchResults removeObjectForKey:service];
        else
            [nonZeroSearchResults setObject:results forKey:service];
    }
    
    NSLog(@"Non-zero search results: %@", nonZeroSearchResults);
}

#pragma mark Static helper methods

+ (NSArray *)filterResults:(NSArray *)results byText:(NSString *)text
{
    const NSRange notFoundRange = NSMakeRange(NSNotFound, 0);
    
    NSMutableArray * filteredResults = [NSMutableArray array];
    
    for (NSString * result in results)
        if (!NSEqualRanges([result rangeOfString:text], notFoundRange))
            [filteredResults addObject:result];
    
    return filteredResults;
}

@end
