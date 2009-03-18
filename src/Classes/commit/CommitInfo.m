//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CommitInfo.h"

@implementation CommitInfo

@synthesize details;

- (id)initWithDetails:(NSDictionary *)someDetails
{
    if (self = [super init])
        details = [someDetails copy];

    return self;
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithDetails:details];
}

@end
