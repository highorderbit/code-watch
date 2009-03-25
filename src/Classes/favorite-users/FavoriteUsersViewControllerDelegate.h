//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FavoriteUsersViewControllerDelegate

- (void)viewWillAppear;
- (void)removedUsername:(NSString *)username;

@end
