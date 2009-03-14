//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username;
@synthesize details;
@synthesize repos;

- (void)dealloc
{
    [username release];
    [details release];
    [repos release];
    [super dealloc];
}

- (id)initWithUsername:(NSString *)aUsername
    details:(NSDictionary *)someDetails repos:(NSArray *)someRepos
{
    aUsername = [aUsername copy];
    [username release];
    username = aUsername;
    
    someDetails = [someDetails copy];
    [someDetails release];
    details = someDetails;
    
    someRepos = [someRepos copy];
    [repos release];
    repos = someRepos;
    
    return self;
}

@end
