//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUserViewControllerDelegate.h"
#import "NameValueTextEntryTableViewCell.h"

@interface AddUserViewController : UITableViewController <UITextFieldDelegate>
{
    NSObject<AddUserViewControllerDelegate> * delegate;
    
    IBOutlet UITableView * tableView;
    
    NameValueTextEntryTableViewCell * usernameCell;
    UITableViewCell * helpCell;
    
    IBOutlet UITextField * usernameTextField;
}

@end
