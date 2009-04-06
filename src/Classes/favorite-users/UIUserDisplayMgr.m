//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIUserDisplayMgr.h"
#import "GitHubService.h"
#import "GravatarService.h"

@interface UIUserDisplayMgr (Private)

- (void)createNewContact;
- (void)addToExistingContact;
+ (void)mergeStringProperty:(NSInteger)property
    fromContact:(ABRecordRef)fromContact
    toContact:(ABRecordRef)toContact;
+ (void)mergeMultiValueProperty:(NSInteger)property
    fromContact:(ABRecordRef)fromContact
    toContact:(ABRecordRef)toContact;

@end

@implementation UIUserDisplayMgr

@synthesize contactToAdd;

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [userViewController release];

    [userCacheReader release];
    [avatarCacheReader release];
    [repoSelector release];
    [avatarCacheReader release];
    [gitHubService release];
    [gravatarService release];
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
    avatarCacheReader:
    (NSObject<AvatarCacheReader> *)anAvatarCacheReader
    repoSelector:
    (NSObject<RepoSelector> *)aRepoSelector
    gitHubService:
    (GitHubService *)aGitHubService
    gravatarService:
    (GravatarService *)aGravatarService
    contactCacheSetter:
    (NSObject<ContactCacheSetter> *)aContactCacheSetter
{
    if (self = [super init]) {
        navigationController = [aNavigationController retain];
        networkAwareViewController = [aNetworkAwareViewController retain];
        userViewController = [aUserViewController retain];
        userCacheReader = [aUserCacheReader retain];
        avatarCacheReader = [anAvatarCacheReader retain];
        repoSelector = [aRepoSelector retain];
        gitHubService = [aGitHubService retain];
        gravatarService = [aGravatarService retain];
        contactCacheSetter = [aContactCacheSetter retain];
        
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];
            
        UIBarButtonItem * refreshButton =
            [[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
            target:self
            action:@selector(displayUserInfo)] autorelease];

        [networkAwareViewController.navigationItem
            setRightBarButtonItem:refreshButton animated:NO];
    }
    
    return self;
}

- (void)viewWillAppear
{
    [self displayUserInfo];
}

- (void)displayUserInfo
{
    [gitHubService fetchInfoForUsername:username];

    UserInfo * userInfo = [userCacheReader userWithUsername:username];
    NSString * email = [userInfo.details objectForKey:@"email"];
    if (email) {
        UIImage * avatar = [avatarCacheReader avatarForEmailAddress:email];
        [userViewController updateWithAvatar:avatar];
    }

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
    [userViewController updateWithUserInfo:info];

    NSString * email = [info.details objectForKey:@"email"];
    if (email)
        [gravatarService fetchAvatarForEmailAddress:email];
    else
        [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];

    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [networkAwareViewController setUpdatingState:kDisconnected];
}

#pragma mark GravatarServiceDelegate implementation

- (void)avatar:(UIImage *)avatar fetchedForEmailAddress:(NSString *)emailAddress
{
    [userViewController updateWithAvatar:avatar];
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
    error:(NSError *)error
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

#pragma mark Property implementations

- (UIViewController *)tabViewController
{
    return navigationController.parentViewController;
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

        if (!ABPersonHasImageData(person)) {
            CFDataRef newImage = ABPersonCopyImageData(contactToAdd);
            ABPersonSetImageData(person, newImage, &error);
        }
     
        // write person to adress book
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRemoveRecord(addressBook, person, &error);
        ABAddressBookAddRecord(addressBook, person, &error);
        ABAddressBookSave(addressBook, &error);
    
        ABRecordID recordId = ABRecordGetRecordID(person);
        [contactCacheSetter setRecordId:recordId forUser:username];
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
