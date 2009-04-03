//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "PrimaryUserDisplayMgr.h"

@implementation PrimaryUserDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [userViewController release];
    
    [userCache release];
    [logInState release];
    [contactCacheSetter release];
    
    [repoSelector release];
    
    [gitHub release];
    
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
        
        [gitHub fetchInfoForUsername:logInState.login];

        UserInfo * userInfo = [userCache primaryUser];
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

    [networkAwareViewController setCachedDataAvailable:YES];
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
        [contactCacheSetter setRecordId:recordId forUser:logInState.login];
    }
    
    [self.tabViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark Property implementations

- (UIViewController *)tabViewController
{
    return navigationController.parentViewController;
}

@end
