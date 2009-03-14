//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserViewController : UITableViewController {
    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;

    IBOutlet UILabel * usernameLabel;    
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * emailLabel;
    
    User * user;
}

- (void)updateWithUser:(User *)user;

@end
