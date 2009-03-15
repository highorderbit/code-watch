//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserViewController : UITableViewController {
    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;
    IBOutlet UIImageView * avatarView;
    
    IBOutlet UILabel * usernameLabel;    
    IBOutlet UILabel * featuredDetail1Label;
    IBOutlet UILabel * featuredDetail2Label;
    
    User * user;
    
    NSString * featuredDetail1Key;
    NSString * featuredDetail2Key;
    
    NSMutableDictionary * nonFeaturedDetails;
}

- (void)updateWithUser:(User *)user;

- (void)setFeaturedDetail1Key:(NSString *)key;
- (void)setFeaturedDetail2Key:(NSString *)key;

- (void)setAvatarFilename:(NSString *)filename;

@end
