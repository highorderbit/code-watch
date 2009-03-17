//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UIApplication+NetworkActivityIndicatorAdditions.h"

static NSInteger networkActivityCount;

@implementation UIApplication (NetworkActivityIndicatorAdditions)

- (void)networkActivityIsStarting
{
    if (networkActivityCount++ == 0)
        self.networkActivityIndicatorVisible = YES;
}

- (void)networkActivityDidFinish
{
    if (--networkActivityCount == 0)
        self.networkActivityIndicatorVisible = NO;
}

@end
