//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoInfo.h"

@implementation RepoInfo

@synthesize details;

- (void)dealloc
{
    [details release];
    [super dealloc];
}

- (id)initWithDetails:(NSDictionary *)someDetails
{
    if (self = [super init])
        details = [someDetails copy];

    return self;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    RepoInfo * copy =
        [[[self class] allocWithZone:zone] initWithDetails:details];

    return copy;
}

@end
