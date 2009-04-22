//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddRepoViewControllerDelegate.h"
#import "FavoriteReposStateReader.h"
#import "NameValueTextEntryTableViewCell.h"

@interface AddRepoViewController : UITableViewController <UITextFieldDelegate>
{
    NSObject<AddRepoViewControllerDelegate> * delegate;
    NSObject<FavoriteReposStateReader> * favoriteReposStateReader;
    
    IBOutlet UITableView * tableView;
    
    NameValueTextEntryTableViewCell * usernameCell;
    NameValueTextEntryTableViewCell * repoNameCell;
    UITableViewCell * helpCell;
    
    IBOutlet UITextField * usernameTextField;
    IBOutlet UITextField * repoNameTextField;
}

@property (nonatomic, retain)
    NSObject<AddRepoViewControllerDelegate> * delegate;
@property (nonatomic, retain)
    NSObject<FavoriteReposStateReader> * favoriteReposStateReader;

- (void)promptForRepo;
- (void)repoAccepted;
- (void)repoRejected;

@end
