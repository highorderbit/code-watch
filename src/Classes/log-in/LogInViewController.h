//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NameValueTextEntryTableViewCell;

@interface LogInViewController : UITableViewController
{
    UITableView * tableView;

    NameValueTextEntryTableViewCell * usernameCell;
    NameValueTextEntryTableViewCell * tokenCell;
}

@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) NameValueTextEntryTableViewCell * usernameCell;
@property (nonatomic, retain) NameValueTextEntryTableViewCell * tokenCell;

@end
