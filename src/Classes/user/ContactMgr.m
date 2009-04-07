//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ContactMgr.h"

@interface ContactMgr (Private)

- (void)createNewContact;
- (void)addToExistingContact;
+ (void)mergeStringProperty:(NSInteger)property
    fromContact:(ABRecordRef)fromContact
    toContact:(ABRecordRef)toContact;
+ (void)mergeMultiValueProperty:(NSInteger)property
    fromContact:(ABRecordRef)fromContact
    toContact:(ABRecordRef)toContact;

@end
    
@implementation ContactMgr

@synthesize contactToAdd;
@synthesize username;

- (void)dealloc
{
    [tabViewController release];
    [contactCacheSetter release];

    [username release];

    [super dealloc];
}

- (void)userDidAddContact:(ABRecordRef)person forUser:(NSString *)aUsername
{
    self.contactToAdd = person;
    self.username = aUsername;
    
    UIActionSheet * actionSheet =
        [[[UIActionSheet alloc]
        initWithTitle:nil delegate:self
        cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
        otherButtonTitles:@"Create New Contact", @"Add to Existing Contact",
        nil]
        autorelease];

    [actionSheet showInView:tabViewController.view];
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
    
    [tabViewController dismissModalViewControllerAnimated:YES];
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
    
    [tabViewController dismissModalViewControllerAnimated:YES];
    
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
    [tabViewController dismissModalViewControllerAnimated:YES];
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
    
    [tabViewController presentModalViewController:addContactNavController
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
    
    [tabViewController presentModalViewController:peoplePickerController
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
