//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchService.h"

@protocol SearchServiceDelegate

- (void)processSearchResults:(NSArray *)results
    fromSearchService:(NSObject<SearchService> *)searchService;

@end
