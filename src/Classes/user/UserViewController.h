//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "UserViewControllerDelegate.h"
#import "RecentActivityDisplayMgr.h"
#import "ContactCacheReader.h"
#import "ContactMgr.h"

@interface UserViewController : UITableViewController
{
    IBOutlet NSObject<UserViewControllerDelegate> * delegate;
    IBOutlet ContactMgr * contactMgr;
    IBOutlet NSObject<RecentActivityDisplayMgr> * recentActivityDisplayMgr;
    IBOutlet NSObject<ContactCacheReader> * contactCacheReader;

    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;
    IBOutlet UIImageView * avatarView;
    IBOutlet UILabel * usernameLabel;
    IBOutlet UILabel * featuredDetail1Label;
    IBOutlet UIButton * featuredDetail2Button;
    IBOutlet UIButton * addToContactsButton;
        
    NSString * username;
    UserInfo * userInfo;
    NSMutableDictionary * repoAccessRights;
    
    NSString * featuredDetail1Key;
    NSString * featuredDetail2Key;
    
    NSMutableDictionary * nonFeaturedDetails;

    UIImage * avatar;
}

@property (nonatomic, retain) NSObject<UserViewControllerDelegate> * delegate;
@property (nonatomic, retain) ContactMgr * contactMgr;
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
- (IBAction)sendEmail:(id)sender;

- (void)scrollToTop;

- (void)setAccess:(BOOL)access forRepoName:(NSString *)repoKey;

@end
