//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchServiceDelegate.h"

@interface SearchViewController :
    UIViewController
    <UITableViewDataSource, UISearchBarDelegate, SearchServiceDelegate>
{
    IBOutlet UITableView * tableView;
    IBOutlet UISearchBar * searchBar;
    NSObject<SearchService> * searchService;
    
    NSDictionary * searchResults;
    NSMutableDictionary * nonZeroSearchResults;
}

- (id)initWithSearchService:(NSObject<SearchService> *)aSearchService;
@property (nonatomic, retain) NSDictionary * searchResults;

@end
