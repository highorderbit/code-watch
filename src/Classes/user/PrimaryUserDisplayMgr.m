//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "PrimaryUserDisplayMgr.h"
#import "GitHubService.h"
#import "GravatarService.h"
#import "GravatarServiceFactory.h"
#import "NewsFeedDisplayMgr.h"
#import "NewsFeedDisplayMgrFactory.h"

@interface PrimaryUserDisplayMgr (Private)

- (UIImage *)cachedAvatarForUserInfo:(UserInfo *)info;
- (NewsFeedDisplayMgr *)newsFeedDisplayMgr;
- (void)setRepoAccessRights:(UserInfo*)userInfo;

@end

@implementation PrimaryUserDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [userViewController release];
    
    [userCache release];
    [repoCache release];
    [logInState release];
    [contactCacheSetter release];
    [avatarCache release];
    
    [repoSelector release];
    
    [gitHubService release];

    [gravatarService release];
    [gravatarServiceFactory release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    UIBarButtonItem * refreshButton =
        [[[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
        target:self
        action:@selector(displayUserInfo)] autorelease];

    [networkAwareViewController.navigationItem
        setRightBarButtonItem:refreshButton animated:NO];

    gravatarService = [gravatarServiceFactory createGravatarService];
    gravatarService.delegate = self;
}

- (void)viewWillAppear
{
    [self displayUserInfo];
}

- (void)displayUserInfo
{
    gitHubFailure = NO;
    avatarFailure = NO;
    
    if (logInState && logInState.login) {
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];
        
        [gitHubService fetchInfoForUsername:logInState.login];

        UserInfo * userInfo = [userCache primaryUser];
        UIImage * avatar = [self cachedAvatarForUserInfo:userInfo];
        
        if (avatar)
            [userViewController updateWithAvatar:avatar];
        [userViewController setUsername:logInState.login];
        [userViewController updateWithUserInfo:userInfo];
        if (userInfo)
            [self setRepoAccessRights:userInfo];
            
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        [networkAwareViewController setCachedDataAvailable:!!userInfo];
    } else {
        // This is a bit of a hack, but a relatively simple solution:
        // Configure the network-aware controller to 'disconnected' and set the
        // disconnected text accordingly
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"userdisplaymgr.login.text", @"")];
        [networkAwareViewController setUpdatingState:kDisconnected];
        [networkAwareViewController setCachedDataAvailable:NO];
    }
}

- (void)setRepoAccessRights:(UserInfo *)userInfo
{
    for (NSString * repoName in userInfo.repoKeys) {
        RepoInfo * repoInfo = [repoCache primaryUserRepoWithName:repoName];
        if (repoInfo)
            [userViewController
                setAccess:[[repoInfo.details objectForKey:@"private"] boolValue]
                forRepoName:repoName];
        else
            [gitHubService fetchInfoForRepo:repoName username:logInState.login];
    }
}

#pragma mark UserViewControllerDelegate implementation

- (void)userDidSelectRepo:(NSString *)repo
{
    [repoSelector user:logInState.login didSelectRepo:repo];
}

- (void)userDidSelectRecentActivity
{
    [[self newsFeedDisplayMgr] updateActivityFeedForPrimaryUser];
}

- (void)userDidSelectFollowing
{
}

- (void)userDidSelectFollowers
{
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    UIImage * avatar = [self cachedAvatarForUserInfo:info];

    for (NSString * repoName in [repos allKeys]) {
        RepoInfo * repoInfo = [repos objectForKey:repoName];
        BOOL private = [[repoInfo.details objectForKey:@"private"] boolValue];
        [userViewController setAccess:private forRepoName:repoName];
    }

    if (avatar)
        [userViewController updateWithAvatar:avatar];
    [userViewController updateWithUserInfo:info];

    [networkAwareViewController setCachedDataAvailable:YES];

    NSString * email = [info.details objectForKey:@"email"];
    if (email)
        [gravatarService fetchAvatarForEmailAddress:email];
    else
        [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    if (!gitHubFailure) {
        gitHubFailure = YES;
        NSLog(@"Failed to retrieve info for user: '%@' error: '%@'.", username,
            error);

        NSString * title =
            NSLocalizedString(@"github.userupdate.failed.alert.title", @"");
        NSString * cancelTitle =
            NSLocalizedString(@"github.userupdate.failed.alert.ok", @"");
        NSString * message = error.localizedDescription;

        UIAlertView * alertView =
            [[[UIAlertView alloc]
              initWithTitle:title
                    message:message
                   delegate:self
          cancelButtonTitle:cancelTitle
          otherButtonTitles:nil]
             autorelease];

        [alertView show];

        [networkAwareViewController setUpdatingState:kDisconnected];
    }
}
    
- (void)avatar:(UIImage *)avatar
    fetchedForEmailAddress:(NSString *)emailAddress
{
    [userViewController updateWithAvatar:avatar];
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
                                     error:(NSError *)error
{
    if (!avatarFailure) {
        avatarFailure = YES;
        NSLog(@"Failed to retrieve avatar for email address: '%@' error: '%@'.",
            emailAddress, error);

        NSString * title =
            NSLocalizedString(@"gravatar.userupdate.failed.alert.title", @"");
        NSString * cancelTitle =
            NSLocalizedString(@"gravatar.userupdate.failed.alert.ok", @"");
        NSString * message = error.localizedDescription;

        UIAlertView * alertView =
            [[[UIAlertView alloc]
              initWithTitle:title
                    message:message
                   delegate:self
          cancelButtonTitle:cancelTitle
          otherButtonTitles:nil]
             autorelease];

        [alertView show];

        [networkAwareViewController setUpdatingState:kDisconnected];
    }
}

#pragma mark NewsFeedDisplayMgrDelegate

- (void)userDidRequestRefresh
{
    [[self newsFeedDisplayMgr] updateActivityFeedForPrimaryUser];
}

#pragma mark Working with avatars

- (UIImage *)cachedAvatarForUserInfo:(UserInfo *)info
{
    NSString * email = [info.details objectForKey:@"email"];
    return email ? [avatarCache avatarForEmailAddress:email] : nil;
}

#pragma mark Accessors

- (NewsFeedDisplayMgr *)newsFeedDisplayMgr
{
    if (!newsFeedDisplayMgr) {
        newsFeedDisplayMgr =
            [newsFeedDisplayMgrFactory
            createNewsFeedDisplayMgr:navigationController];
        newsFeedDisplayMgr.delegate = self;
    }

    return newsFeedDisplayMgr;
}

@end
