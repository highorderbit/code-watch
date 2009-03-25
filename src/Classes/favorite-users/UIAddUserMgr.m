//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIAddUserMgr.h"

@implementation UIAddUserMgr

- (void)dealloc
{
    [rootViewController release];
    [addUserViewController release];
    [super dealloc];
}

#pragma mark AddUserMgr implementation

- (void)addUser
{
    [rootViewController presentModalViewController:addUserViewController
        animated:YES];
}

#pragma mark AddUserControllerDelegate implementation

- (void)userProvidedUsername:(NSString *)username
{}

- (void)userDidCancel
{}

- (void)provideHelp
{}

@end
