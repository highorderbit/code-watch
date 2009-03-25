//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteUsersViewControllerDelegate.h"

@interface FavoriteUsersViewController : UITableViewController
{
    IBOutlet NSObject<FavoriteUsersViewControllerDelegate> * delegate;
    NSMutableArray * sortedUsernames;
    
    UIBarButtonItem * rightButton;
}

- (void)setUsernames:(NSArray *)usernames;

@end
