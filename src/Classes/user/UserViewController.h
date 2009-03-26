//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "UserViewControllerDelegate.h"
#import "FavoriteUsersStateSetter.h"
#import "FavoriteUsersStateReader.h"

@interface UserViewController : UITableViewController
{
    IBOutlet NSObject<UserViewControllerDelegate> * delegate;
    IBOutlet NSObject<FavoriteUsersStateSetter> * favoriteUsersStateSetter;
    IBOutlet NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;

    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;
    IBOutlet UIImageView * avatarView;
    IBOutlet UILabel * usernameLabel;    
    IBOutlet UILabel * featuredDetail1Label;
    IBOutlet UILabel * featuredDetail2Label;
    IBOutlet UIButton * addToFavoritesButton;
        
    NSString * username;
    UserInfo * userInfo;
    
    NSString * featuredDetail1Key;
    NSString * featuredDetail2Key;
    
    NSMutableDictionary * nonFeaturedDetails;
}

@property (nonatomic, retain) NSObject<UserViewControllerDelegate> * delegate;
@property (nonatomic, retain)
    NSObject<FavoriteUsersStateSetter> * favoriteUsersStateSetter;
@property (nonatomic, retain)
    NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;

- (void)setUsername:(NSString *)username;
- (void)updateWithUserInfo:(UserInfo *)userInfo;

- (void)setFeaturedDetail1Key:(NSString *)key;
- (void)setFeaturedDetail2Key:(NSString *)key;

- (void)setAvatarFilename:(NSString *)filename;

- (IBAction)addContact:(id)sender;
- (IBAction)addFavorite:(id)sender;

@end
