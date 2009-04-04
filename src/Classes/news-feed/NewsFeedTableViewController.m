//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "RssItem.h"
#import "NewsFeedTableViewCell.h"
#import "NSString+RegexKitLiteHelpers.h"

@interface NewsFeedTableViewController (Private)

- (void)setRssItems:(NSArray *)someRssItems;
- (void)setAvatars:(NSDictionary *)someAvatars;

@end

@implementation NewsFeedTableViewController

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

    NSString * head = [rssItem.summary stringByMatchingRegex:
        @"HEAD is <a href=\".*\">(.*)</a>"];
    NSString * summary =
        head ? [NSString stringWithFormat:@"HEAD is %@", head] : nil;
    UIImage * avatar = [avatars objectForKey:rssItem.author];

    [cell updateAuthor:rssItem.author pubDate:rssItem.pubDate
        subject:rssItem.subject summary:summary avatar:avatar];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tv
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
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

#pragma mark Accessors

- (void)setRssItems:(NSArray *)someRssItems
{
    NSArray * tmp = [someRssItems copy];
    [rssItems release];
    rssItems = tmp;
}

- (void)setAvatars:(NSDictionary *)someAvatars
{
    NSDictionary * tmp = [someAvatars copy];
    [avatars release];
    avatars = tmp;
}

@end
