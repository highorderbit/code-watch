//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeWatchAppController.h"

@interface CodeWatchAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow* window;
    UITabBarController* tabBarController;
    CodeWatchAppController* appController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet UITabBarController* tabBarController;
@property (nonatomic, retain) IBOutlet CodeWatchAppController* appController;

@end
