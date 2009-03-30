//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController

- (void)dealloc
{
    [tableView release];
    [searchServices release];
    [super dealloc];
}

- (id)initWithSearchServices:(NSDictionary *)someSearchServices
{
    if (self = [super init])
        searchServices = [someSearchServices retain];

    return self;
}

#pragma mark UIViewController implementation

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView
    numberOfRowsInSection:(NSInteger)section
{
    return 0;
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
    
//    cell.text = ...;

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

#pragma mark UISearchBarDelegate implementation

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Searching all services for '%@'...", searchText);
    for(NSObject<SearchService> * service in [searchServices allValues])
        [service searchForText:searchText];
}

#pragma mark SearchServiceDelegate implementation

- (void)processSearchResults:(NSArray *)results
    fromSearchService:(NSObject<SearchService> *)searchService
{
}

@end
