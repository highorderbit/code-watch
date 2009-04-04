//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedTableViewControllerDelegate.h"

@interface NewsFeedTableViewController : UITableViewController
{
    IBOutlet NSObject<NewsFeedTableViewControllerDelegate> * delegate;

    NSArray * rssItems;
    NSMutableDictionary * avatars;
}

- (void)updateRssItems:(NSArray *)someRssItems;
- (void)updateAvatars:(NSDictionary *)someAvatars;
- (void)updateAvatar:(UIImage *)avatar forUsername:(NSString *)username;

@end
