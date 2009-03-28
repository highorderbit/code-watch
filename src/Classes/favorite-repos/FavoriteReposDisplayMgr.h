//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteReposViewControllerDelegate.h"
#import "FavoriteReposViewController.h"

@interface FavoriteReposDisplayMgr :
    NSObject <FavoriteReposViewControllerDelegate>
{
    FavoriteReposViewController * viewController;
}

- (id)initWithViewController:(FavoriteReposViewController *)viewController;

@end
