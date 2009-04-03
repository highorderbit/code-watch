//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RssItem.h"

@class RepoKey;

@interface RssItem (ParsingHelpers)

- (RepoKey *)repoKey;

@end
