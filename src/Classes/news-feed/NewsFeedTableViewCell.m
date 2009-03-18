//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "NSDate+StringHelpers.h"

@implementation NewsFeedTableViewCell

- (void)dealloc {
    [authorLabel release];
    [pubDateLabel release];
    [subjectLabel release];
    [summaryLabel release];
    [super dealloc];
}

- (void)updateAuthor:(NSString *)author pubDate:(NSDate *)pubDate
    subject:(NSString *)subject summary:(NSString *)summary
{
    authorLabel.text = author;
    pubDateLabel.text = [pubDate shortDescription];
    subjectLabel.text = subject;
    summaryLabel.text = summary;
}
    
@end
