//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UserInfo.h"
#import "NSObject+RuntimeAdditions.h"

@implementation UserInfo

@synthesize details;
@synthesize repoKeys;

- (void)dealloc
{
    [details release];
    [repoKeys release];
    [super dealloc];
}

- (id)copy
{
    return [self retain]; // because immutable
}

- (id)initWithDetails:(NSDictionary *)someDetails
    repoKeys:(NSArray *)someRepoKeys
{
    someDetails = [someDetails copy];
    [details release];
    details = someDetails;
    
    someRepoKeys = [someRepoKeys copy];
    [repoKeys release];
    repoKeys = someRepoKeys;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%d):\ndetails: %@\nrepo keys: %@",
        [self className], (NSUInteger) self, details, repoKeys];
}

@end
