//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubService.h"

@implementation GitHubService

- (void)dealloc
{
    [gitHub release];
    [super dealloc];
}

#pragma mark Instantiation

+ (id)service
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
    return self = [super init];
}

#pragma mark Fetching user info from GitHub

- (void)fetchInfoForUsername:(NSString *)username
{
    [gitHub fetchInfoForUsername:username];
}

- (void)fetchInfoForUsername:(NSString *)username token:(NSString *)token
{
    [gitHub fetchInfoForUsername:username token:token];
}

#pragma mark GitHubDelegate implementation

- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username
{
}

@end
