//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CodeWatchAppDelegate.h"
#import "UIAlertView+CreationHelpers.h"

#if defined (HOB_SHOW_MEMORY_WARNING_ALERT)

static BOOL displayWarning = NO;

#endif

@implementation CodeWatchAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize appController;

- (void) dealloc
{
    [tabBarController release];
    [appController release];
    [window release];

    [userCacheSetter release];
    [repoCacheSetter release];
    [commitCacheSetter release];
    [newsFeedCacheSetter release];
    [avatarCacheSetter release];

    [super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    [window addSubview:tabBarController.view];
    [appController start];
}

- (void) applicationWillTerminate:(UIApplication*)application
{
    [appController persistState];
}

#if defined (HOB_SHOW_MEMORY_WARNING_ALERT)

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"WARNING: application received memory warning.");

    [userCacheSetter clear];
    [repoCacheSetter clear];
    [commitCacheSetter clear];
    [newsFeedCacheSetter clear];
    [avatarCacheSetter clear];

    if (!displayWarning) {
        NSString * title = @"Memory Warning Received";
        NSString * message =
            @"The application has received a request to release some memory."
            "\n\nTap \"Show Again\" to show this alert the next time a memory "
            "warning is received.";

        NSString * nextButtonTitle = @"Show Again";
        NSString * okButtonTitle = @"Dismiss";

        UIAlertView * alert =
            [[[UIAlertView alloc] initWithTitle:title message:message
            delegate:self cancelButtonTitle:nextButtonTitle
            otherButtonTitles:okButtonTitle, nil] autorelease];

        [alert show];
    }
}

#pragma mark UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        displayWarning = NO;
}

#endif

@end
