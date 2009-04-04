//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUserViewControllerDelegate.h"
#import "NameValueTextEntryTableViewCell.h"
#import "FavoriteUsersStateReader.h"

@interface AddUserViewController : UITableViewController <UITextFieldDelegate>
{
    NSObject<AddUserViewControllerDelegate> * delegate;
    NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
    
    IBOutlet UITableView * tableView;
    
    NameValueTextEntryTableViewCell * usernameCell;
    UITableViewCell * helpCell;
    
    IBOutlet UITextField * usernameTextField;
}

@property (nonatomic, retain)
    NSObject<AddUserViewControllerDelegate> * delegate;
@property (nonatomic, retain)
    NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
    
- (void)promptForUsername;
- (void)usernameAccepted;
    
@end
