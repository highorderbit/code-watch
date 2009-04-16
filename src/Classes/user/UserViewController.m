//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserViewController.h"
#import "NSObject+RuntimeAdditions.h"
#import "HOTableViewCell.h"
#import "UserDetailTableViewCell.h"
#import "UIAlertView+CreationHelpers.h"
#import "UIImage+AvatarHelpers.h"
#import <AddressBookUI/ABPersonViewController.h>

enum Section
{
    kUserDetailsSection,
    kRecentActivitySection,
    kRepoSection
};

@interface UserViewController (Private)

- (void)updateNonFeaturedDetails;
- (NSInteger)effectiveSectionForSection:(NSInteger)section;
- (UITableViewCell *)createCellForSection:(NSInteger)section;
- (NSString *)reuseIdentifierForSection:(NSInteger)section;
+ (NSString *)blogKey;
+ (NSString *)companyKey;
+ (NSString *)emailKey;
+ (NSString *)nameKey;

@end

@implementation UserViewController

@synthesize delegate;
@synthesize contactMgr;
@synthesize favoriteUsersStateSetter;
@synthesize favoriteUsersStateReader;
@synthesize recentActivityDisplayMgr;
@synthesize contactCacheReader;

- (void) dealloc
{
    [delegate release];
    [contactMgr release];
    [favoriteUsersStateSetter release];
    [favoriteUsersStateReader release];
    [recentActivityDisplayMgr release];
    [contactCacheReader release];
    
    [headerView release];
    [footerView release];
    [avatarView release];
    [usernameLabel release];
    [featuredDetail1Label release];
    [featuredDetail2Label release];
    [addToFavoritesButton release];
    [addToContactsButton release];

    [username release];
    [userInfo release];
    
    [nonFeaturedDetails release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setFeaturedDetail1Key:@"name"];
    [self setFeaturedDetail2Key:@"email"];
    
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = headerView;
        
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = footerView;
    
    [addToFavoritesButton setTitleColor:[UIColor grayColor]
        forState:UIControlStateDisabled];
        
    [addToContactsButton setTitleColor:[UIColor grayColor]
        forState:UIControlStateDisabled];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (userInfo && userInfo.details) {
        usernameLabel.text = username;
        
        NSString * name = [userInfo.details objectForKey:featuredDetail1Key];
        featuredDetail1Label.text = name ? name : @"";
        
        NSString * email = [userInfo.details objectForKey:featuredDetail2Key];
        featuredDetail2Label.text = email ? email : @"";
    }
    
    addToFavoritesButton.enabled =
        ![favoriteUsersStateReader.favoriteUsers containsObject:username];

    // allow adding to contacts iff not already added or not in the address book
    ABRecordID recordId = [contactCacheReader recordIdForUser:username];
    ABRecordRef person =
        ABAddressBookGetPersonWithRecordID(ABAddressBookCreate(), recordId);
    addToContactsButton.enabled = recordId == kABRecordInvalidID || !person;
    
    // fixes a bug where the scroll indicator region is incorrectly set after
    // the logout action sheet is shown
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // this is a hack to fix an occasional bug exhibited on the device where the
    // selected cell isn't deselected
    [self.tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tv
{
    NSInteger numSections = 1;
    
    if ([nonFeaturedDetails count] > 0)
        numSections++;
    if (userInfo.repoKeys && [userInfo.repoKeys count] > 0)
        numSections++;
        
    return numSections;
}

- (NSInteger)tableView:(UITableView*)tv
    numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    switch ([self effectiveSectionForSection:section]) {
        case kUserDetailsSection:
            numRows = [nonFeaturedDetails count];
            break;
        case kRecentActivitySection:
            numRows = 1;
            break;
        case kRepoSection:
            numRows = [userInfo.repoKeys count];
            break;
    }
    
    return numRows;
}

- (UITableViewCell*)tableView:(UITableView*)tv
    cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString * reuseIdentifier =
        [self reuseIdentifierForSection:indexPath.section];
    UITableViewCell * cell =
        [tv dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [self createCellForSection:indexPath.section];
    
    UserDetailTableViewCell * detailCell;
    switch ([self effectiveSectionForSection:indexPath.section]) {
        case kUserDetailsSection:
            detailCell = (UserDetailTableViewCell *)cell;
            NSString * key =
                [[nonFeaturedDetails allKeys] objectAtIndex:indexPath.row];
            NSString * value = [nonFeaturedDetails objectForKey:key];
            [detailCell setKeyText:key];
            [detailCell setValueText:value];
            detailCell.selectionStyle =
                [key isEqual:[[self class] blogKey]] ?
                UITableViewCellSelectionStyleBlue :
                UITableViewCellSelectionStyleNone;
            break;
        case kRecentActivitySection:
            cell.text = NSLocalizedString(@"user.recent.activity.label", @"");
            break;
        case kRepoSection:
            cell.text = [userInfo.repoKeys objectAtIndex:indexPath.row];
            break;
    }
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tv
    titleForHeaderInSection:(NSInteger)section
{
    return [self effectiveSectionForSection:section] == kRepoSection &&
        userInfo.repoKeys && [userInfo.repoKeys count] > 0 ?
        NSLocalizedString(@"user.repo.header.label", @"") : nil;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*)tv
    accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
    NSInteger section = [self effectiveSectionForSection:indexPath.section];
    return (section == kRecentActivitySection || section == kRepoSection) ?
        UITableViewCellAccessoryDisclosureIndicator :
        UITableViewCellAccessoryNone;
}

- (NSIndexPath *)tableView:(UITableView *)tv
    willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self effectiveSectionForSection:indexPath.section];
    NSString * detailKey =
        [[nonFeaturedDetails allKeys] objectAtIndex:indexPath.row];

    return section == kUserDetailsSection &&
        ![detailKey isEqual:[[self class] blogKey]] ?
        nil :
        indexPath;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger effectiveSection =
        [self effectiveSectionForSection:indexPath.section];
    NSString * repo = [userInfo.repoKeys objectAtIndex:indexPath.row];
    NSString * detailKey =
        [[nonFeaturedDetails allKeys] objectAtIndex:indexPath.row];
    NSString * detailValue = [nonFeaturedDetails objectForKey:detailKey];
    switch (effectiveSection) {
        case kRepoSection:
            [delegate userDidSelectRepo:repo];
            break;
        case kRecentActivitySection:
            [delegate userDidSelectRecentActivity];
            break;
        case kUserDetailsSection:
            if ([detailKey isEqual:[[self class] blogKey]]) {
                NSLog(@"Opening blog in Safari: %@", detailValue);
                NSURL * url = [NSURL URLWithString:detailValue];
                [[UIApplication sharedApplication] openURL:url];
            }
            break;
    }
}

#pragma mark User data update methods

- (void)setUsername:(NSString *)aUsername
{
    aUsername = [aUsername copy];
    [username release];
    username = aUsername;
    
    usernameLabel.text = username;
}

- (void)updateWithUserInfo:(UserInfo *)someUserInfo
{
    someUserInfo = [someUserInfo copy];
    [userInfo release];
    userInfo = someUserInfo;
    
    [self updateNonFeaturedDetails];
    
    [self.tableView reloadData];
}

- (void)updateWithAvatar:(UIImage *)avatar
{
    avatarView.image = avatar ? avatar : [UIImage imageUnavailableImage];
}

- (void)setFeaturedDetail1Key:(NSString *)key
{
    key = [key copy];
    [featuredDetail1Key release];
    featuredDetail1Key = key;
    
    [self updateNonFeaturedDetails];
}

- (void)setFeaturedDetail2Key:(NSString *)key
{
    key = [key copy];
    [featuredDetail2Key release];
    featuredDetail2Key = key;
    
    [self updateNonFeaturedDetails];
}

- (void)setAvatarFilename:(NSString *)filename
{
    avatarView.image = [UIImage imageNamed:filename];
}

#pragma mark Helper methods

- (void)updateNonFeaturedDetails
{
    [nonFeaturedDetails release];
    nonFeaturedDetails = [[NSMutableDictionary alloc] init];
    
    NSDictionary * details = userInfo.details;
    for (NSString * key in [details allKeys])
        if (![key isEqual:featuredDetail1Key] &&
            ![key isEqual:featuredDetail2Key]) {
            
            NSString * detail = [details objectForKey:key];
            [nonFeaturedDetails setObject:detail forKey:key];
        }
}

- (NSInteger)effectiveSectionForSection:(NSInteger)section
{
    return [nonFeaturedDetails count] > 0 ? section : section + 1;
}

- (UITableViewCell *)createCellForSection:(NSInteger)section
{
    UITableViewCell * cell;
    
    NSArray * nib;
    switch ([self effectiveSectionForSection:section]) {
        case kUserDetailsSection:
            nib =
                [[NSBundle mainBundle] loadNibNamed:@"UserDetailTableViewCell"
                owner:self options:nil];
            cell = [nib objectAtIndex:0];
            break;
        default:
            cell = [[[HOTableViewCell alloc] initWithFrame:CGRectZero
                reuseIdentifier:@"UITableViewCell"
                tableViewStyle:UITableViewStyleGrouped]
                autorelease];
            break;
    }
    
    return cell;
}

- (NSString *)reuseIdentifierForSection:(NSInteger)section
{
    return ([self effectiveSectionForSection:section] == kUserDetailsSection) ?
        @"UserDetailTableViewCell" : @"UITableViewCell";
}

- (IBAction)addContact:(id)sender
{
    NSLog(@"Displaying 'add contact' sheet...");
    ABRecordRef person = ABPersonCreate();
    CFErrorRef error = NULL;
    
    NSDictionary * details = userInfo.details;
    
    NSArray * nameComponents =
        [[details objectForKey:@"name"] componentsSeparatedByString:@" "];
    NSUInteger nameCompsCount = nameComponents ? [nameComponents count] : 0;
    NSString * firstName =
        nameCompsCount > 0 ? [nameComponents objectAtIndex:0] : nil;
    NSString * lastName =
        nameCompsCount > 1 ?
        [nameComponents objectAtIndex:nameCompsCount - 1] : nil;
    NSString * companyName = [details objectForKey:[[self class] companyKey]];
    NSString * emailAddress = [details objectForKey:[[self class] emailKey]];
    NSString * blog = [details objectForKey:[[self class] blogKey]];
    
    ABRecordSetValue(person, kABPersonFirstNameProperty, firstName, &error);
    ABRecordSetValue(person, kABPersonLastNameProperty, lastName, &error);
    ABRecordSetValue(person, kABPersonOrganizationProperty, companyName,
        &error);

    if (emailAddress) {
        ABMutableMultiValueRef emailAddresses =
            ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(emailAddresses, emailAddress, kABHomeLabel,
            NULL);
        ABRecordSetValue(person, kABPersonEmailProperty, emailAddresses,
            &error);
    }
    if (blog) {
        ABMutableMultiValueRef blogs =
            ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(blogs, blog, kABHomeLabel, NULL);
        ABRecordSetValue(person, kABPersonURLProperty, blogs, &error);
    }
    
    NSData * data = UIImagePNGRepresentation(avatarView.image);
    ABPersonSetImageData(person, (CFDataRef)data, &error);

    [contactMgr userDidAddContact:person forUser:username];
}

- (IBAction)addFavorite:(id)sender
{
    NSLog(@"Adding user '%@' to favorites...", username);
    [favoriteUsersStateSetter addFavoriteUser:username];
    addToFavoritesButton.enabled = NO;
}

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:self.tableView.frame animated:NO];
}

#pragma mark User detail keys

+ (NSString *)blogKey
{
    return @"blog";
}

+ (NSString *)companyKey
{
    return @"company";
}

+ (NSString *)emailKey
{
    return @"email";
}

+ (NSString *)nameKey
{
    return @"name";
}

@end
