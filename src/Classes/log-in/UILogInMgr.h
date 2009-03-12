//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"

@interface UILogInMgr : NSObject <LogInMgr>
{
    IBOutlet UIViewController* rootViewController;
    IBOutlet UIViewController* logInViewController;
}

@end
