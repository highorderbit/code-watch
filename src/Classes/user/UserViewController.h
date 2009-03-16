//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserViewController : UITableViewController {
    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;
    IBOutlet UIImageView * avatarView;
    
    IBOutlet UILabel * usernameLabel;    
    IBOutlet UILabel * featuredDetail1Label;
    IBOutlet UILabel * featuredDetail2Label;
        
    NSString * username;
    UserInfo * userInfo;
    
    NSString * featuredDetail1Key;
    NSString * featuredDetail2Key;
    
    NSMutableDictionary * nonFeaturedDetails;
}

- (void)setUsername:(NSString *)username;
- (void)updateWithUserInfo:(UserInfo *)userInfo;

- (void)setFeaturedDetail1Key:(NSString *)key;
- (void)setFeaturedDetail2Key:(NSString *)key;

- (void)setAvatarFilename:(NSString *)filename;

@end
