//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AvatarCacheReader <NSObject, NSFastEnumeration>

- (UIImage *)avatarForEmailAddress:(NSString *)emailAddress;

@end
