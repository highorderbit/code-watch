//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedItemViewController.h"
#import "RssItem.h"
#import "UILabel+DrawingAdditions.h"

static NSUInteger NUM_SECTIONS = 1;
enum Sections
{
    kDetailsSections
};

static NSUInteger NUM_DETAILS_ROWS = 1;
enum DetailsSectionRows
{
    kDetailsRow
};

@interface NewsFeedItemViewController (Private)

- (void)updateDisplay;
- (void)setRssItem:(RssItem *)item;

@end

@implementation NewsFeedItemViewController

@synthesize delegate, rssItem;

- (void)dealloc
{
    [delegate release];
    [headerView release];
    [authorLabel release];
    [subjectLabel release];
    [avatarImageView release];
    [rssItem release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = headerView;

    self.navigationItem.title =
        NSLocalizedString(@"newsfeeditem.view.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateDisplay];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return NUM_SECTIONS;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger nrows = 0;

    switch (section) {
        case kDetailsSections:
            nrows = NUM_DETAILS_ROWS;
            break;
    }

    return nrows;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";

    UITableViewCell * cell =
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
        cell =
            [[[UITableViewCell alloc]
              initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]
             autorelease];

    cell.text = NSLocalizedString(@"newsfeeditem.details.label", @"");
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)          tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate userDidSelectDetails:rssItem];
}

#pragma mark Updating the display

- (void)updateWithRssItem:(RssItem *)item
{
    [self setRssItem:item];

    [self updateDisplay];
}

- (void)updateDisplay
{
    authorLabel.text = rssItem.author;

    CGFloat height = [subjectLabel heightForString:rssItem.subject];

    CGRect newFrame = subjectLabel.frame;
    newFrame.size.height = height;

    subjectLabel.frame = newFrame;
    subjectLabel.text = rssItem.subject;

    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = 85.0 + height;
    headerView.frame = headerFrame;

    self.tableView.tableHeaderView = headerView;

    [self.tableView reloadData];
}

#pragma mark Accessors

- (void)setRssItem:(RssItem *)item
{
    RssItem * tmp = [item copy];
    [rssItem release];
    rssItem = tmp;
}

@end
