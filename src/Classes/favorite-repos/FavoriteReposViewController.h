//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteReposViewControllerDelegate.h"

@interface FavoriteReposViewController : UITableViewController
{
    NSObject<FavoriteReposViewControllerDelegate> * delegate;
    NSMutableArray * sortedRepoKeys;
    
    UIBarButtonItem * rightButton;
}

@property (nonatomic, retain)
    NSObject<FavoriteReposViewControllerDelegate> * delegate;

- (void)setRepoKeys:(NSArray *)repoKeys;

@end
