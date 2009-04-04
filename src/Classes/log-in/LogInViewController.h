//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInViewControllerDelegate.h"

@class NameValueTextEntryTableViewCell;

@interface LogInViewController : UITableViewController
                                 < UITextFieldDelegate >
{
    NSObject<LogInViewControllerDelegate> * delegate;

    UITableView * tableView;

    NameValueTextEntryTableViewCell * usernameCell;
    NameValueTextEntryTableViewCell * tokenCell;
    UITableViewCell * helpCell;

    UITextField * usernameTextField;
    UITextField * tokenTextField;
}

@property (nonatomic, retain) NSObject<LogInViewControllerDelegate> * delegate;
@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) NameValueTextEntryTableViewCell * usernameCell;
@property (nonatomic, retain) NameValueTextEntryTableViewCell * tokenCell;
@property (nonatomic, retain) UITableViewCell * helpCell;
@property (nonatomic, retain) IBOutlet UITextField * usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField * tokenTextField;

- (void)promptForLogIn;
- (void)logInAccepted;

@end
