//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UserViewController.h"
#import "NSObject+RuntimeAdditions.h"
#import "UserDetailTableViewCell.h"

static const NSInteger NUM_SECTIONS = 3;

enum Section
{
    kUserDetailsSection,
    kRecentActivitySection,
    kRepoSection
};

@interface UserViewController (Private)

- (void)updateNonFeaturedDetails;

+ (UITableViewCell *)createCellForSection:(NSInteger)section;
+ (NSString *)reuseIdentifierForSection:(NSInteger)section;

@end

@implementation UserViewController

- (void) dealloc
{
    [headerView release];
    [footerView release];
    [avatarView release];
    
    [usernameLabel release];
    [featuredDetail1Label release];
    [featuredDetail2Label release];

    [username release];
    [userInfo release];
    
    [nonFeaturedDetails release];
    
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // TEMPORARY
    NSDictionary * someDetails =
        [[NSDictionary alloc] initWithObjectsAndKeys:
        @"Doug Kurth", @"name", @"Boulder, CO", @"location",
        @"doug@highorderbit.com", @"email", nil];
    NSArray * someRepos =
        [NSArray arrayWithObjects:@"build-watch", @"code-watch", nil];
    userInfo =
        [[UserInfo alloc] initWithDetails:someDetails repoKeys:someRepos];

    [self setUsername:@"kurthd"];
    [self setFeaturedDetail1Key:@"name"];
    [self setFeaturedDetail2Key:@"email"];
    // TEMPORARY

    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = headerView;
    
    if (userInfo && userInfo.details) {
        usernameLabel.text = username;
        
        NSString * name = [userInfo.details objectForKey:featuredDetail1Key];
        featuredDetail1Label.text = name ? name : @"";
        
        NSString * email = [userInfo.details objectForKey:featuredDetail2Key];
        featuredDetail2Label.text = email ? email : @"";
    }
        
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = footerView;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSIndexPath * selectedRow = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedRow animated:NO];
}

#pragma mark Table view methods

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tv
{
    return NUM_SECTIONS;
}

- (NSInteger) tableView:(UITableView*)tv
    numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    switch (section) {
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
        [[self class] reuseIdentifierForSection:indexPath.section];
    UITableViewCell * cell =
        [tv dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[self class] createCellForSection:indexPath.section];
    
    UserDetailTableViewCell * detailCell;
    switch (indexPath.section) {
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
    return section == kRepoSection ?
        NSLocalizedString(@"user.repo.header.label", @"") : nil;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*)tv
    accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
    return (indexPath.section == kRecentActivitySection ||
        indexPath.section == kRepoSection) ?
        UITableViewCellAccessoryDisclosureIndicator :
        UITableViewCellAccessoryNone;
}

- (NSIndexPath *)tableView:(UITableView *)tv
    willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == kUserDetailsSection ? nil : indexPath;
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
    nonFeaturedDetails = [[[NSMutableDictionary alloc] init] retain];
    
    NSDictionary * details = userInfo.details;
    for (NSString * key in [details allKeys])
        if (![key isEqual:featuredDetail1Key] &&
            ![key isEqual:featuredDetail2Key]) {
            
            NSString * detail = [details objectForKey:key];
            [nonFeaturedDetails setObject:detail forKey:key];
        }
}

#pragma mark Static helper methods

+ (UITableViewCell *)createCellForSection:(NSInteger)section
{
    UITableViewCell * cell;
    
    NSArray * nib;
    switch (section) {
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

+ (NSString *)reuseIdentifierForSection:(NSInteger)section
{
    return (section == kUserDetailsSection) ?
        @"UserDetailTableViewCell" : @"UITableViewCell";
}

@end
