//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "UserViewControllerDelegate.h"
#import "FavoriteUsersStateSetter.h"
#import "FavoriteUsersStateReader.h"
#import "RecentActivityDisplayMgr.h"
#import "ContactCacheReader.h"
#import "ContactMgr.h"

@interface UserViewController : UITableViewController
{
    IBOutlet NSObject<UserViewControllerDelegate> * delegate;
    IBOutlet ContactMgr * contactMgr;
    IBOutlet NSObject<FavoriteUsersStateSetter> * favoriteUsersStateSetter;
    IBOutlet NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
    IBOutlet NSObject<RecentActivityDisplayMgr> * recentActivityDisplayMgr;
    IBOutlet NSObject<ContactCacheReader> * contactCacheReader;

    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;
    IBOutlet UIImageView * avatarView;
    IBOutlet UILabel * usernameLabel;    
    IBOutlet UILabel * featuredDetail1Label;
    IBOutlet UILabel * featuredDetail2Label;
    IBOutlet UIButton * addToFavoritesButton;
    IBOutlet UIButton * addToContactsButton;
        
    NSString * username;
    UserInfo * userInfo;
    
    NSString * featuredDetail1Key;
    NSString * featuredDetail2Key;
    
    NSMutableDictionary * nonFeaturedDetails;
}

@property (nonatomic, retain) NSObject<UserViewControllerDelegate> * delegate;
@property (nonatomic, retain) ContactMgr * contactMgr;
@property (nonatomic, retain)
    NSObject<FavoriteUsersStateSetter> * favoriteUsersStateSetter;
@property (nonatomic, retain)
    NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
@property (nonatomic, retain)
    NSObject<RecentActivityDisplayMgr> * recentActivityDisplayMgr;
@property (nonatomic, retain)
    NSObject<ContactCacheReader> * contactCacheReader;

- (void)setUsername:(NSString *)username;
- (void)updateWithUserInfo:(UserInfo *)userInfo;
- (void)updateWithAvatar:(UIImage *)avatar;

- (void)setFeaturedDetail1Key:(NSString *)key;
- (void)setFeaturedDetail2Key:(NSString *)key;

- (IBAction)addContact:(id)sender;
- (IBAction)addFavorite:(id)sender;

- (void)scrollToTop;

@end
