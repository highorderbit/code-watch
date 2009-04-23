//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeWatchAppController.h"
#import "NewsFeedCacheSetter.h"

@interface CodeWatchAppDelegate :
    NSObject <UIApplicationDelegate>
{
    UIWindow * window;
    UITabBarController * tabBarController;
    CodeWatchAppController * appController;
    
    IBOutlet NSObject<UserCacheSetter> * userCacheSetter;
    IBOutlet NSObject<RepoCacheSetter> * repoCacheSetter;
    IBOutlet NSObject<CommitCacheSetter> * commitCacheSetter;
    IBOutlet NSObject<NewsFeedCacheSetter> * newsFeedCacheSetter;
    IBOutlet NSObject<AvatarCacheSetter> * avatarCacheSetter;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, retain) IBOutlet UITabBarController * tabBarController;
@property (nonatomic, retain) IBOutlet CodeWatchAppController * appController;

@end
