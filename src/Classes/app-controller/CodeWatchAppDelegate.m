//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CodeWatchAppDelegate.h"

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
    // fix tab bar text
    
    
    [window addSubview:tabBarController.view];
    [appController start];
}

- (void) applicationWillTerminate:(UIApplication*) application
{
    [appController persistState];
}

@end

