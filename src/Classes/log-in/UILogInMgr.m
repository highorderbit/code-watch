//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"

@implementation UILogInMgr

- (void) dealloc
{
    [rootViewController release];
    [logInViewController release];
    [super dealloc];
}

- (void) collectCredentials
{
    [rootViewController
        presentModalViewController:logInViewController
        animated:YES];
}

@end
