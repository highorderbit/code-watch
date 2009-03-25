//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FavoriteUsersStateSetter

- (void)addFavoriteUser:(NSString *)username;
- (void)removeFavoriteUser:(NSString *)username;

@end
