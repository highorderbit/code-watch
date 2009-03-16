//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDisplayMgr.h"
#import "CodeWatchDisplayMgr.h"

@interface CodeWatchNavigationController : UINavigationController
{
    IBOutlet NSObject<CodeWatchDisplayMgr> * displayMgr;
}

@end
