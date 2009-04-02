//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubNewsFeedServiceFactory.h"
#import "GitHubNewsFeedService.h"

@implementation GitHubNewsFeedServiceFactory

- (void)dealloc
{
    [configReader release];    
    [logInStateReader release];
    [newsFeedCache release];
    [newsFeedPersistenceStore release];
    [super dealloc];
}

- (GitHubNewsFeedService *)createGitHubNewsFeedService
{
    NSString * baseUrl = [configReader valueForKey:@"GitHubNewsFeedBaseUrl"];
    return [[[GitHubNewsFeedService alloc]
        initWithBaseUrl:baseUrl logInStateReader:logInStateReader] autorelease];
}

@end