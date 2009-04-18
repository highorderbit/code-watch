//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CodeWatchAppDelegate.h"
#import "UIAlertView+CreationHelpers.h"

@implementation CodeWatchAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize appController;

- (void) dealloc
{
    [tabBarController release];
    [appController release];
    [window release];
    [super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication*) application
{
    [application
        setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];

    [window addSubview:tabBarController.view];
    [appController start];
}

- (void) applicationWillTerminate:(UIApplication*) application
{
    [appController persistState];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    static BOOL warningDisplayed = NO;

    NSLog(@"WARNING: application received memory warning.");

    if (!warningDisplayed) {
        NSString * title = @"Memory Warning Received";
        NSString * message =
            @"The application has received a request to release some memory. "
            "This alert will not be shown again, but future occurrences will "
            "be logged.";
        UIAlertView * alert =
            [UIAlertView simpleAlertViewWithTitle:title message:message];
        [alert show];

        warningDisplayed = YES;
    }
}

@end
