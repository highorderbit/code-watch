//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RssItem+ParsingHelpers.h"
#import "RepoKey.h"
#import "NSString+RegexKitLiteHelpers.h"

@implementation RssItem (ParsingHelpers)

- (RepoKey *)repoKey
{
    NSString * user =
        [self.subject stringByMatchingRegex:@"([^ ]+?)/[^\\s]+"];
    NSString * repo =
        [self.subject stringByMatchingRegex:@"\\s.+/([^\\s]+)"];

    if (user && repo)
        return [RepoKey keyWithUsername:user repoName:repo];
    return nil;
}

@end
