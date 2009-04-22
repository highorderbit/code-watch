//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedViewControllerDelegate.h"

@interface NewsFeedViewController : UITableViewController
{
    IBOutlet id<NewsFeedViewControllerDelegate> delegate;

    NSArray * rssItems;
    NSMutableDictionary * avatars;
}

@property (nonatomic, retain) id<NewsFeedViewControllerDelegate> delegate;

- (void)updateRssItems:(NSArray *)someRssItems;
- (void)updateAvatars:(NSDictionary *)someAvatars;
- (void)updateAvatar:(UIImage *)avatar forUsername:(NSString *)username;

- (void)scrollToTop;

@end
