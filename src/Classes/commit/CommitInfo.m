//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CommitInfo.h"
#import "NSObject+RunTimeAdditions.h"

@implementation CommitInfo

@synthesize details, changesets;

- (void)dealloc
{
    [details release];
    [changesets release];
    [super dealloc];
}

- (id)initWithDetails:(NSDictionary *)someDetails
{
    return [self initWithDetails:someDetails changesets:nil];
}

- (id)initWithDetails:(NSDictionary *)someDetails
           changesets:(NSDictionary *)someChangesets
{
    if (self = [super init]) {
        details = [someDetails copy];
        changesets = [someChangesets copy];
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@\n%@", [self className], details,
        changesets];
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone]
        initWithDetails:details changesets:changesets];
}

@end
