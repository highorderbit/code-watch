//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GravatarDelegate <NSObject>

- (void)avatar:(UIImage *)avatar
    fetchedForEmailAddress:(NSString *)emailAddress;
- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
    error:(NSError *)error;

@end
