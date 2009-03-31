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
    NSDictionary * searchServices;
    
    NSMutableDictionary * searchResults;
    NSMutableDictionary * nonZeroSearchResults;
    NSString * lastSearchedText;
}

- (id)initWithSearchServices:(NSDictionary *)searchServices;

@end
