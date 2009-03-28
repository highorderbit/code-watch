//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteReposViewControllerDelegate.h"
#import "FavoriteReposViewController.h"
#import "FavoriteReposStateReader.h"
#import "FavoriteReposStateSetter.h"

@interface FavoriteReposDisplayMgr :
    NSObject <FavoriteReposViewControllerDelegate>
{
    FavoriteReposViewController * viewController;
    
    NSObject<FavoriteReposStateReader> * favoriteReposStateReader;
    NSObject<FavoriteReposStateSetter> * favoriteReposStateSetter;
}

- (id)initWithViewController:(FavoriteReposViewController *)viewController
    stateReader:(NSObject<FavoriteReposStateReader> *)favoriteReposStateReader
    stateSetter:(NSObject<FavoriteReposStateSetter> *)favoriteReposStateSetter;

@end
