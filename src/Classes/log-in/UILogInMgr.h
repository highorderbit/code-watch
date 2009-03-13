//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"

@class LogInViewController;

@interface UILogInMgr : NSObject <LogInMgr>
{
    IBOutlet UIViewController * rootViewController;
    LogInViewController * logInViewController;
}

@property (nonatomic, retain) LogInViewController * logInViewController;

@end
