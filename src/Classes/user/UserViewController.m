//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UserViewController.h"
#import "NSObject+RuntimeAdditions.h"
#import "UserDetailTableViewCell.h"
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

@end

@implementation UserViewController

@synthesize delegate;
@synthesize favoriteUsersStateSetter;
@synthesize favoriteUsersStateReader;
@synthesize recentActivityDisplayMgr;

- (void) dealloc
{
    [delegate release];
    [favoriteUsersStateSetter release];
    [favoriteUsersStateReader release];
    [recentActivityDisplayMgr release];
    
    [headerView release];
    [footerView release];
    [avatarView release];
    [usernameLabel release];
    [featuredDetail1Label release];
    [featuredDetail2Label release];
    [addToFavoritesButton release];

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    NSIndexPath * selectedRow = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedRow animated:NO];
    
    if (userInfo && userInfo.details) {
        usernameLabel.text = username;
        
        NSString * name = [userInfo.details objectForKey:featuredDetail1Key];
        featuredDetail1Label.text = name ? name : @"";
        
        NSString * email = [userInfo.details objectForKey:featuredDetail2Key];
        featuredDetail2Label.text = email ? email : @"";
    }
    
    addToFavoritesButton.enabled =
        ![favoriteUsersStateReader.favoriteUsers containsObject:username];
}

#pragma mark Table view methods

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tv
{
    NSInteger numSections = 1;
    
    if ([nonFeaturedDetails count] > 0)
        numSections++;
    if (userInfo.repoKeys && [userInfo.repoKeys count] > 0)
        numSections++;
        
    return numSections;
}

- (NSInteger) tableView:(UITableView*)tv
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

- (UITableViewCell*) tableView:(UITableView*)tv
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

- (NSString*) tableView:(UITableView *)tv
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
    return section == kUserDetailsSection ? nil : indexPath;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger effectiveSection =
        [self effectiveSectionForSection:indexPath.section];
    if (effectiveSection == kRepoSection) {
        NSString * repo = [userInfo.repoKeys objectAtIndex:indexPath.row];
        [delegate userDidSelectRepo:repo];
    } else if (effectiveSection == kRecentActivitySection)
        [recentActivityDisplayMgr displayRecentHistoryForUser:username];
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
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
                reuseIdentifier:@"UITableViewCell"]
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
    NSLog(@"Adding contact");
    // display modal ABPersonViewController
    ABPersonViewController * personViewController =
        [[ABPersonViewController alloc] init];
    [self presentModalViewController:personViewController animated:YES];
    [personViewController release];
}

- (IBAction)addFavorite:(id)sender
{
    [favoriteUsersStateSetter addFavoriteUser:username];
    addToFavoritesButton.enabled = NO;
}

@end
