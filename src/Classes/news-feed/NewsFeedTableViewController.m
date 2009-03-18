//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "RssItem.h"
#import "NewsFeedTableViewCell.h"

@implementation NewsFeedTableViewController

- (void)dealloc {
    [rssItems release];
    [super dealloc];
}

- (void)awakeFromNib
{
    // TEMPORARY: set some rssItems
    
    NSMutableArray * tempRssItems = [NSMutableArray array];
    
    NSDate * now = [NSDate date];
    
    NSString * author1 = @"jad";
    NSString * subject1 = @"jad pushed to master at highorderbit/code-watch";
    NSString * summary1 = @"HEAD is a94a0aa279ed58a8286966659ae85bb74b4f8544   John A. Debay committed a94a0aa2:  Reading GitHub API version from Info.plist.   John A. Debay committed 752607c2:  Merge branch 'master' of git@github.com:highorderbit/code-watch   John A. Debay committed c43f458c:  Reading GitHub API format from Info.plist.";
    
    RssItem * update1 =
        [[RssItem alloc] initWithAuthor:author1 pubDate:now subject:subject1
        summary:summary1];
    
    NSString * author2 = @"mrtrumbe";
    NSString * subject2 = @"mrtrumbe started watching euphoria/thrifty";
    NSString * summary2 = @"thrifty's description: Thrifty is a Python-based parser generator for Apache Thrift sourc";
    
    RssItem * update2 =
        [[RssItem alloc] initWithAuthor:author2 pubDate:now subject:subject2
        summary:summary2];
    
    [tempRssItems addObject:update1];
    [tempRssItems addObject:update2];
    
    [self updateRssItems:tempRssItems];
    
    // TEMPORARY
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

    [cell updateAuthor:rssItem.author pubDate:rssItem.pubDate
        subject:rssItem.subject summary:rssItem.summary];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tv
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

#pragma mark Data updating methods

- (void)updateRssItems:(NSArray *)someRssItems
{
    someRssItems = [someRssItems copy];
    [rssItems release];
    rssItems = someRssItems;
    
    // update view
}

@end
