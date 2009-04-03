//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIUserDisplayMgr.h"

@implementation UIUserDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [userViewController release];

    [userCacheReader release];
    [repoSelector release];
    [gitHubService release];
    [contactCacheSetter release];

    [username release];
    
    [super dealloc];
}

- (id)initWithNavigationController:
    (UINavigationController *)aNavigationController
    networkAwareViewController:
    (NetworkAwareViewController *)aNetworkAwareViewController
    userViewController:
    (UserViewController *)aUserViewController
    userCacheReader:
    (NSObject<UserCacheReader> *)aUserCacheReader
    repoSelector:
    (NSObject<RepoSelector> *)aRepoSelector
    gitHubService:
    (GitHubService *)aGitHubService
    contactCacheSetter:
    (NSObject<ContactCacheSetter> *)aContactCacheSetter
{
    if (self = [super init]) {
        navigationController = aNavigationController;
        networkAwareViewController = aNetworkAwareViewController;
        userViewController = aUserViewController;
        userCacheReader = aUserCacheReader;
        repoSelector = aRepoSelector;
        gitHubService = aGitHubService;
        contactCacheSetter = aContactCacheSetter;
        
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];
    }
    
    return self;
}

- (void)viewWillAppear
{
    [gitHubService fetchInfoForUsername:username];

    UserInfo * userInfo = [userCacheReader userWithUsername:username];
    [userViewController setUsername:username];
    [userViewController updateWithUserInfo:userInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:!!userInfo];
}

#pragma mark UserViewControllerDelegate implementation

- (void)userDidSelectRepo:(NSString *)repo
{
    [repoSelector user:username didSelectRepo:repo];
}

- (void)userDidAddContact:(ABRecordRef)person
{
    ABNewPersonViewController * personViewController =
        [[ABNewPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    personViewController.addressBook = ABAddressBookCreate();
    personViewController.newPersonViewDelegate = self;
    
    UINavigationController * addContactNavController =
        [[UINavigationController alloc]
        initWithRootViewController:personViewController];
    
    [self.tabViewController presentModalViewController:addContactNavController
        animated:YES];

    [addContactNavController release];
    [personViewController release];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    [userViewController updateWithUserInfo:info];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [networkAwareViewController setUpdatingState:kDisconnected];
}

#pragma mark UserDisplayMgr implementation

- (void)displayUserInfoForUsername:(NSString *)aUsername
{
    aUsername = [aUsername copy];
    [username release];
    username = aUsername;
    
    [navigationController
        pushViewController:networkAwareViewController animated:YES];
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"user.view.title", @"");
}

#pragma mark ABNewPersonViewControllerDelegate implementation

- (void)newPersonViewController:
    (ABNewPersonViewController *)newPersonViewController
    didCompleteWithNewPerson:
    (ABRecordRef)person
{
    if (person) {
        ABRecordID recordId = ABRecordGetRecordID(person);
        NSLog(@"Created person with record id %@",
            [NSNumber numberWithInt:recordId]);
        [contactCacheSetter setRecordId:recordId forUser:username];
    }
    
    [self.tabViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark Property implementations

- (UIViewController *)tabViewController
{
    return navigationController.parentViewController;
}

@end
