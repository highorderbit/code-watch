//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FollowingDisplayMgr.h"

#import "UserNetworkDisplayMgr.h"
#import "GitHubService.h"
#import "UIAlertView+CreationHelpers.h"

@interface FollowingDisplayMgr (Private)

- (void)setUsername:(NSString *)aUsername;

@end

@implementation FollowingDisplayMgr

- (void)dealloc
{
    [navigationController release];

    [userNetworkDisplayMgr release];
    [gitHubService release];

    [username release];

    [super dealloc];
}

- (id)initWithNavigationController:(UINavigationController *)nc
                     gitHubService:(GitHubService *)aGitHubService
             userDisplayMgr:(NSObject<UserDisplayMgr> *)aUserDisplayMgr
{
    if (self = [super init]) {
        navigationController = [nc retain];

        userNetworkDisplayMgr =
            [[UserNetworkDisplayMgr alloc]
            initWithUserDisplayMgr:aUserDisplayMgr];
        userNetworkDisplayMgr.delegate = self;

        gitHubService = [aGitHubService retain];
        gitHubService.delegate = self;

        gitHubFailure = NO;
    }

    return self;
}

- (void)displayFollowingForUsername:(NSString *)aUsername
{
    [self setUsername:aUsername];

    gitHubFailure = NO;

    [gitHubService fetchFollowingForUsername:username];

    [userNetworkDisplayMgr setNetwork:nil forUsername:username];
    [userNetworkDisplayMgr setUpdatingState:kConnectedAndUpdating];

    [userNetworkDisplayMgr pushDisplay:navigationController];
}

#pragma mark UserNetworkDisplayMgrDelegate implementation

- (NSString *)titleForNavigationItem
{
    return
        [NSString stringWithFormat:
        NSLocalizedString(@"following.view.title.formatstring", @""),
        username];
}

- (UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem * refreshButtonItem =
        [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
        target:self
        action:@selector(refreshFollowing)];

    return [refreshButtonItem autorelease];
}

#pragma mark GitHubService protocol implementation

- (void)following:(NSArray *)followers fetchedForUsername:(NSString *)aUsername
{
    if ([username isEqualToString:aUsername]) {
        [userNetworkDisplayMgr setNetwork:followers forUsername:aUsername];
        [userNetworkDisplayMgr setUpdatingState:kConnectedAndNotUpdating];
    }
}

- (void)failedToFetchFollowingForUsername:(NSString *)aUsername
                                    error:(NSError *)error
{
    if ([username isEqualToString:aUsername] && !gitHubFailure) {
        gitHubFailure = YES;

        NSLog(@"Failed to retrieve follower list for user: '%@', error: '%@'.",
            username, error);

        NSString * title =
            NSLocalizedString(@"github.followersupdate.failed.alert.title",
            @"");
        NSString * message = error.localizedDescription;

        [[UIAlertView simpleAlertViewWithTitle:title message:message] show];

        [userNetworkDisplayMgr setUpdatingState:kDisconnected];
    }
}

#pragma mark Refreshing the display

- (void)refreshFollowing
{
    gitHubFailure = NO;

    [gitHubService fetchFollowingForUsername:username];

    [userNetworkDisplayMgr setUpdatingState:kConnectedAndUpdating];
}

#pragma mark Accessors

- (void)setUsername:(NSString *)aUsername
{
    NSString * tmp = [aUsername copy];
    [username release];
    username = tmp;
}

@end
