//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteUsersViewControllerDelegate.h"

@interface FavoriteUsersViewController : UITableViewController
{
    NSObject<FavoriteUsersViewControllerDelegate> * delegate;
    NSMutableArray * sortedUsernames;
    
    UIBarButtonItem * rightButton;
}

@property (nonatomic, retain)
    NSObject<FavoriteUsersViewControllerDelegate> * delegate;

- (void)setUsernames:(NSArray *)usernames;

@end
