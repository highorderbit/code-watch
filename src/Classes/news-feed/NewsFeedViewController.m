//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "RssItem.h"
#import "NewsFeedTableViewCell.h"
#import "NSString+RegexKitLiteHelpers.h"
#import "RegexKitLite.h"

@interface NewsFeedViewController (Private)

- (void)setRssItems:(NSArray *)someRssItems;
- (void)setAvatars:(NSDictionary *)someAvatars;

@end

@implementation NewsFeedViewController

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [rssItems release];
    [avatars release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSIndexPath * selectedItem = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedItem animated:animated];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [rssItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tv
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"NewsFeedTableViewCell";
    
    NewsFeedTableViewCell * cell =
        (NewsFeedTableViewCell *)
        [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"NewsFeedTableViewCell"
            owner:self options:nil];
        cell = (NewsFeedTableViewCell *) [nib objectAtIndex:0];
    }
    
    RssItem * rssItem = [rssItems objectAtIndex:indexPath.row];
    UIImage * avatar = [avatars objectForKey:rssItem.author];

    [cell updateAuthor:rssItem.author pubDate:rssItem.pubDate
        subject:rssItem.subject avatar:avatar];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tv
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76.0;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RssItem * item = [rssItems objectAtIndex:indexPath.row];
    [delegate userDidSelectRssItem:item];
}

#pragma mark Data updating methods

- (void)updateRssItems:(NSArray *)someRssItems
{
    [self setRssItems:someRssItems];

    // update view
    [self.tableView reloadData];
}

- (void)updateAvatars:(NSDictionary *)someAvatars
{
    [self setAvatars:someAvatars];

    // update view
    [self.tableView reloadData];
}

- (void)updateAvatar:(UIImage *)avatar forUsername:(NSString *)username
{
    [avatars setObject:avatar forKey:username];

    [self.tableView reloadData];
}

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:self.tableView.frame animated:NO];
}

#pragma mark Accessors

- (void)setRssItems:(NSArray *)someRssItems
{
    NSArray * tmp = [someRssItems copy];
    [rssItems release];
    rssItems = tmp;
}

- (void)setAvatars:(NSDictionary *)someAvatars
{
    NSMutableDictionary * tmp = [someAvatars mutableCopy];
    [avatars release];
    avatars = tmp;
}

@end
