//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewCell : UITableViewCell {
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * pubDateLabel;
    IBOutlet UILabel * subjectLabel;
    IBOutlet UILabel * summaryLabel;
    IBOutlet UIImageView * avatarImageView;
}

- (void)updateAuthor:(NSString *)author pubDate:(NSDate *)pubDate
    subject:(NSString *)subject summary:(NSString *)summary
    avatar:(UIImage *)avatar;

@end
