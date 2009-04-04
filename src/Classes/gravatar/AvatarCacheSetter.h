//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AvatarCacheSetter <NSObject>

- (void)setAvatar:(UIImage *)avatar forEmailAddress:(NSString *)emailAddress;

@end
