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

@end

@implementation PrimaryUserDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [userViewController release];
    
    [userCache release];
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

#pragma mark UserViewControllerDelegate implementation

- (void)userDidSelectRepo:(NSString *)repo
{
    [repoSelector user:logInState.login didSelectRepo:repo];
}

- (void)userDidSelectRecentActivity
{
    [[self newsFeedDisplayMgr] updateNewsFeedForPrimaryUser];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    UIImage * avatar = [self cachedAvatarForUserInfo:info];

    if (avatar)
        [userViewController updateWithAvatar:avatar];
    [userViewController updateWithUserInfo:info];

    [networkAwareViewController setCachedDataAvailable:YES];

    NSString * email = [info.details objectForKey:@"email"];
    if (email)
        [gravatarService fetchAvatarForEmailAddress:email];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
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

- (void)avatar:(UIImage *)avatar
    fetchedForEmailAddress:(NSString *)emailAddress
{
    [userViewController updateWithAvatar:avatar];
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
                                     error:(NSError *)error
{
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
    if (!newsFeedDisplayMgr)
        newsFeedDisplayMgr =
            [newsFeedDisplayMgrFactory
            createNewsFeedDisplayMgr:navigationController];

    return newsFeedDisplayMgr;
}

@end
