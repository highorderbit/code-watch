//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UserInfo.h"

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
    return self; // because immutable
}

- (id)initWithDetails:(NSDictionary *)someDetails
    repoKeys:(NSArray *)someRepoKeys
{
    someDetails = [someDetails copy];
    [someDetails release];
    details = someDetails;
    
    someRepoKeys = [someRepoKeys copy];
    [repoKeys release];
    repoKeys = someRepoKeys;
    
    return self;
}

@end
