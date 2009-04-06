//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "PrimaryUserDisplayMgr.h"
#import "GitHubService.h"
#import "GravatarService.h"
#import "GravatarServiceFactory.h"

@interface PrimaryUserDisplayMgr (Private)

- (UIImage *)cachedAvatarForUserInfo:(UserInfo *)info;
- (void)createNewContact;
- (void)addToExistingContact;
+ (void)mergeStringProperty:(NSInteger)property
    fromContact:(ABRecordRef)fromContact
    toContact:(ABRecordRef)toContact;
+ (void)mergeMultiValueProperty:(NSInteger)property
    fromContact:(ABRecordRef)fromContact
    toContact:(ABRecordRef)toContact;

@end

@implementation PrimaryUserDisplayMgr

@synthesize contactToAdd;

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

- (void)userDidAddContact:(ABRecordRef)person
{
    self.contactToAdd = person;
    
    UIActionSheet * actionSheet =
        [[[UIActionSheet alloc]
        initWithTitle:nil delegate:self
        cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
        otherButtonTitles:@"Create New Contact", @"Add to Existing Contact",
        nil]
        autorelease];

    [actionSheet showInView:self.tabViewController.view];
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

#pragma mark Working with avatars

- (UIImage *)cachedAvatarForUserInfo:(UserInfo *)info
{
    NSString * email = [info.details objectForKey:@"email"];
    return email ? [avatarCache avatarForEmailAddress:email] : nil;
}

#pragma mark Property implementations

- (UIViewController *)tabViewController
{
    return navigationController.parentViewController;
}

#pragma mark UIActionSheetDelegate implementation

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self createNewContact];
            break;
        case 1:
            [self addToExistingContact];
            break;
    }
}

#pragma mark ABPeoplePickerNavigationController implementation

- (BOOL)peoplePickerNavigationController:
    (ABPeoplePickerNavigationController *)peoplePicker
    shouldContinueAfterSelectingPerson:
    (ABRecordRef)person
{
    if (person) {
        CFErrorRef error = NULL;
        
        /* TOTAL HACK:
        *  I'm sure there's a better way, but I gave up trying to figure out
        *  what it is...  Unexpectedly, reading and then writing an ABRecordRef
        *  to the database will lose all properties but first and last name.
        *  This would seem to imply that the properties aren't set, but they can
        *  be read with an ABRecordCopyValue call.  If the properties are reset,
        *  they will be properly saved to the address book.  The following
        *  for-loop forces all properties to be set.  It seems that the
        *  consecutive constants 0 - 39 are valid property keys...
        */
        for (int i = 0; i < 39; i++)
            ABRecordSetValue(person, i, ABRecordCopyValue(person, i), &error);
        
        // update person with new properties
        [[self class] mergeStringProperty:kABPersonFirstNameProperty
            fromContact:contactToAdd toContact:person];
    
        [[self class] mergeStringProperty:kABPersonLastNameProperty
            fromContact:contactToAdd toContact:person];
    
        [[self class] mergeStringProperty:kABPersonOrganizationProperty
            fromContact:contactToAdd toContact:person];
    
        [[self class] mergeMultiValueProperty:kABPersonEmailProperty
            fromContact:contactToAdd toContact:person];
        
        [[self class] mergeMultiValueProperty:kABPersonURLProperty
            fromContact:contactToAdd toContact:person];
     
        // write person to adress book
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRemoveRecord(addressBook, person, &error);
        ABAddressBookAddRecord(addressBook, person, &error);
        ABAddressBookSave(addressBook, &error);
    
        ABRecordID recordId = ABRecordGetRecordID(person);
        [contactCacheSetter setRecordId:recordId forUser:logInState.login];
    }
    
    [self.tabViewController dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
    (ABPeoplePickerNavigationController *)peoplePicker
    shouldContinueAfterSelectingPerson:
    (ABRecordRef)person
    property:
    (ABPropertyID)property
    identifier:
    (ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:
    (ABPeoplePickerNavigationController *)peoplePicker
{
    [self.tabViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark Contact management methods

- (void)createNewContact
{
    NSLog(@"Creating a new contact...");
    
    ABNewPersonViewController * personViewController =
        [[ABNewPersonViewController alloc] init];
    personViewController.displayedPerson = contactToAdd;
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

- (void)addToExistingContact
{
    NSLog(@"Adding to existing contacts...");
    
    ABPeoplePickerNavigationController * peoplePickerController =
        [[ABPeoplePickerNavigationController alloc] init];
    peoplePickerController.peoplePickerDelegate = self;
    
    [self.tabViewController presentModalViewController:peoplePickerController
        animated:YES];
    
    [peoplePickerController release];
}

+ (void)mergeStringProperty:(NSInteger)property
    fromContact:(ABRecordRef)fromContact
    toContact:(ABRecordRef)toContact
{
    CFErrorRef error = NULL;
            
    NSString * value =
        (NSString *)ABRecordCopyValue(toContact, property);
    if (!value) {
        NSString * newValue =
            (NSString *)ABRecordCopyValue(fromContact, property);
        ABRecordSetValue(toContact, property, newValue, &error);
    }
}

+ (void)mergeMultiValueProperty:(NSInteger)property
    fromContact:(ABRecordRef)fromContact
    toContact:(ABRecordRef)toContact
{
    CFErrorRef error = NULL;
        
    ABMutableMultiValueRef value =
        ABMultiValueCreateMutableCopy(ABRecordCopyValue(toContact, property));
    
    ABRecordRef recordRef = ABRecordCopyValue(fromContact, property);
    NSArray * newValues = recordRef ?
        (NSArray *)ABMultiValueCopyArrayOfAllValues(recordRef) :
        [NSArray array];
    for (NSString * newValue in newValues)
        ABMultiValueAddValueAndLabel(value, newValue, kABHomeLabel, NULL);
    ABRecordSetValue(toContact, property, value, &error);
}

@end
