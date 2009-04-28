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
#import "UIColor+CodeWatchColors.h"
#import "RepoTableViewCell.h"

enum Section
{
    kUserDetailsSection,
    kRecentActivitySection,
    kRepoSection
};

enum RecentActivityRows
{
    kRecentActivityRow,
    kFollowingRow,
    kFollowersRow
};

@interface UserViewController (Private)

- (void)updateNonFeaturedDetails;
- (NSInteger)effectiveSectionForSection:(NSInteger)section;
- (UITableViewCell *)createCellForSection:(NSInteger)section;
- (NSString *)reuseIdentifierForSection:(NSInteger)section;
- (void)setAvatar:(UIImage *)anAvatar;
+ (NSString *)blogKey;
+ (NSString *)locationKey;
+ (NSString *)companyKey;
+ (NSString *)emailKey;
+ (NSString *)nameKey;

@end

@implementation UserViewController

@synthesize delegate;
@synthesize contactMgr;
@synthesize recentActivityDisplayMgr;
@synthesize contactCacheReader;

- (void) dealloc
{
    [delegate release];
    [contactMgr release];
    [recentActivityDisplayMgr release];
    [contactCacheReader release];
    
    [headerView release];
    [footerView release];
    [avatarView release];
    [usernameLabel release];
    [featuredDetail1Label release];
    [featuredDetail2Button release];
    [addToContactsButton release];

    [username release];
    [userInfo release];
    [repoAccessRights release];
    
    [nonFeaturedDetails release];

    [avatar release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setFeaturedDetail1Key:@"name"];
    [self setFeaturedDetail2Key:@"email"];
    
    headerView.backgroundColor = [UIColor codeWatchBackgroundColor];
    self.tableView.tableHeaderView = headerView;
        
    footerView.backgroundColor = [UIColor codeWatchBackgroundColor];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.backgroundColor = [UIColor codeWatchBackgroundColor];
    
    [addToContactsButton setTitleColor:[UIColor grayColor]
        forState:UIControlStateDisabled];
        
    repoAccessRights = [[NSMutableDictionary dictionary] retain];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (userInfo && userInfo.details) {
        usernameLabel.text = username;
        
        NSString * name = [userInfo.details objectForKey:featuredDetail1Key];
        featuredDetail1Label.text = name ? name : @"";
        
        NSString * email = [userInfo.details objectForKey:featuredDetail2Key];
        NSString * emailText = email ? email : @"";
        [featuredDetail2Button setTitle:emailText
            forState:UIControlStateNormal];
        [featuredDetail2Button setTitle:emailText
            forState:UIControlStateHighlighted];
    }

    // allow adding to contacts iff not already added or not in the address book
    ABRecordID recordId = [contactCacheReader recordIdForUser:username];
    ABAddressBookRef addressBook = ABAddressBookCreate();

    ABRecordRef person =
        ABAddressBookGetPersonWithRecordID(addressBook, recordId);
    addToContactsButton.enabled = recordId == kABRecordInvalidID || !person;

    CFRelease(addressBook);

    // fixes a bug where the scroll indicator region is incorrectly set after
    // the logout action sheet is shown
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    avatarView.image = avatar ? avatar : [UIImage imageUnavailableImage];
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
            numRows = 3;
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
    RepoTableViewCell * repoCell;
    switch ([self effectiveSectionForSection:indexPath.section]) {
        case kUserDetailsSection:
            detailCell = (UserDetailTableViewCell *)cell;
            NSString * key =
                [[nonFeaturedDetails allKeys] objectAtIndex:indexPath.row];
            NSString * value = [nonFeaturedDetails objectForKey:key];
            [detailCell setKeyText:key];
            [detailCell setValueText:value];
            detailCell.selectionStyle =
                [key isEqual:[[self class] blogKey]] ||
                [key isEqual:[[self class] locationKey]] ?
                UITableViewCellSelectionStyleBlue :
                UITableViewCellSelectionStyleNone;
            break;
        case kRecentActivitySection:
            switch (indexPath.row) {
                case kRecentActivityRow:
                    cell.text =
                        NSLocalizedString(@"user.recent.activity.label", @"");
                    break;
                case kFollowingRow:
                    cell.text =
                        NSLocalizedString(@"user.following.label", @"");
                    break;
                case kFollowersRow:
                    cell.text =
                        NSLocalizedString(@"user.followers.label", @"");
                    break;
            }
            break;
        case kRepoSection:
            repoCell = (RepoTableViewCell *)cell;
            cell.text = [userInfo.repoKeys objectAtIndex:indexPath.row];
            NSNumber * private = [repoAccessRights objectForKey:cell.text];
            if (private) {
                BOOL privateAsBool = [private boolValue];
                repoCell.icon =
                    privateAsBool ?
                    [UIImage imageNamed:@"private-icon.png"] :
                    [UIImage imageNamed:@"public-icon.png"];
            } else
                repoCell.icon = nil;
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

    if (section == kUserDetailsSection) {
        NSString * detailKey =
            [[nonFeaturedDetails allKeys] objectAtIndex:indexPath.row];
        return
            ![detailKey isEqual:[[self class] blogKey]] &&
            ![detailKey isEqual:[[self class] locationKey]]?
            nil :
            indexPath;
    }

    return indexPath;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger effectiveSection =
        [self effectiveSectionForSection:indexPath.section];
    switch (effectiveSection) {
        case kRepoSection:
            [delegate userDidSelectRepo:
                [userInfo.repoKeys objectAtIndex:indexPath.row]];
            break;
        case kRecentActivitySection:
            switch (indexPath.row) {
                case kRecentActivityRow:
                    [delegate userDidSelectRecentActivity];
                    break;
                case kFollowingRow:
                    [delegate userDidSelectFollowing];
                    break;
                case kFollowersRow:
                    [delegate userDidSelectFollowers];
                    break;
            }
            break;
        case kUserDetailsSection: {
            NSString * detailKey =
                [[nonFeaturedDetails allKeys] objectAtIndex:indexPath.row];
            NSString * detailValue =
                [nonFeaturedDetails objectForKey:detailKey];

            if ([detailKey isEqual:[[self class] blogKey]]) {
                NSLog(@"Opening blog in Safari: %@", detailValue);
                NSURL * url = [NSURL URLWithString:detailValue];
                [[UIApplication sharedApplication] openURL:url];
                // Because some URLS fail to load without notification the
                // following attempts to identify them and deselect the cell
                if ([detailValue rangeOfString:@"http"].location == NSNotFound)
                        [self.tableView deselectRowAtIndexPath:indexPath
                            animated:YES];
            } else if ([detailKey isEqual:[[self class] locationKey]]) {
                NSLog(@"Opening location in Maps: %@", detailValue);
                NSString * locationWithoutCommas =
                    [detailValue stringByReplacingOccurrencesOfString:@","
                    withString:@""];
                NSString * urlString =
                    [[NSString
                    stringWithFormat:@"http://maps.google.com/maps?q=%@",
                    locationWithoutCommas]
                    stringByAddingPercentEscapesUsingEncoding:
                    NSUTF8StringEncoding];
                NSURL * url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }
            break;
        }
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

- (void)updateWithAvatar:(UIImage *)anAvatar
{
    [self setAvatar:anAvatar ? anAvatar : [UIImage imageUnavailableImage]];

    avatarView.image = avatar;
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
        case kRepoSection:
            nib =
                [[NSBundle mainBundle] loadNibNamed:@"RepoTableViewCell"
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
    NSString * cellIdentifier;
    switch ([self effectiveSectionForSection:section]) {
        case kUserDetailsSection:
            cellIdentifier = @"UserDetailTableViewCell";
            break;
        case kRepoSection:
            cellIdentifier = @"RepoTableViewCell";
            break;
        default:
            cellIdentifier = @"UITableViewCell";
            break;
    }
    
    return cellIdentifier;
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
    
    CFRelease(person);
}

- (IBAction)sendEmail:(id)sender
{
    NSString * to = [featuredDetail2Button titleForState:UIControlStateNormal];
    NSString * urlString =
        [[NSString stringWithFormat:@"mailto:%@", to]
        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
}

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:self.tableView.frame animated:NO];
}

- (void)setAvatar:(UIImage *)anAvatar
{
    UIImage * tmp = [anAvatar retain];
    [avatar release];
    avatar = tmp;
}

- (void)setAccess:(BOOL)access forRepoName:(NSString *)repoKey
{
    [repoAccessRights setObject:[NSNumber numberWithBool:access]
        forKey:repoKey];
}

#pragma mark User detail keys

+ (NSString *)blogKey
{
    return @"blog";
}

+ (NSString *)locationKey
{
    return @"location";
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
