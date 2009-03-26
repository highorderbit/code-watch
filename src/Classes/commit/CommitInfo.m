//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CommitInfo.h"
#import "NSObject+RunTimeAdditions.h"

@implementation CommitInfo

@synthesize details;

- (id)initWithDetails:(NSDictionary *)someDetails
{
    if (self = [super init])
        details = [someDetails copy];

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", [self className], details];
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithDetails:details];
}

@end
