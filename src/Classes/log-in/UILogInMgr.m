//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"

@implementation UILogInMgr

@synthesize logInViewController;

- (void) dealloc
{
    [rootViewController release];
    [logInViewController release];
    [super dealloc];
}

- (void) collectCredentials
{
    [rootViewController
        presentModalViewController:self.logInViewController
        animated:YES];
}

#pragma mark Accessors

- (LogInViewController *) logInViewController
{
    if (!logInViewController)
        logInViewController =
            [[[LogInViewController alloc]
              initWithNibName:@"LogInView"
                       bundle:nil]
             autorelease];

    return logInViewController;
}

@end
