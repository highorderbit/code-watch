//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "LogInState.h"

@implementation LogInState

@synthesize login;
@synthesize token;
@synthesize prompt;

- (void) dealloc
{
    [login release];
    [token release];
    [super dealloc];
}

- (void) setLogin:(NSString*)aLogin token:(NSString*)aToken prompt:(BOOL)aPrompt
{
    aLogin = [aLogin copy];
    [login release];
    login = aLogin;
    
    aToken = [aToken copy];
    [token release];
    token = aToken;
    
    prompt = aPrompt;
}

@end
