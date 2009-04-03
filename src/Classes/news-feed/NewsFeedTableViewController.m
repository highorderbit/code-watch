//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "RssItem.h"
#import "NewsFeedTableViewCell.h"
#import "NSString+RegexKitLiteHelpers.h"

@implementation NewsFeedTableViewController

- (void)dealloc {
    [rssItems release];
    [super dealloc];
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

    [cell updateAuthor:rssItem.author pubDate:rssItem.pubDate
        subject:rssItem.subject summary:summary];
    
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
    [self.tableView reloadData];
}

@end
