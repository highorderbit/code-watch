//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteUsersViewControllerDelegate.h"

@interface FavoriteUsersViewController : UITableViewController
{
    IBOutlet NSObject<FavoriteUsersViewControllerDelegate> * delegate;
    NSArray * sortedUsernames;
}

- (void)setUsernames:(NSArray *)usernames;

@end
