//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarDelegate.h"
#import "WebServiceApiDelegate.h"

@class WebServiceApi;

@interface Gravatar : NSObject <WebServiceApiDelegate>
{
    id<GravatarDelegate> delegate;

    NSString * baseUrl;

    WebServiceApi * api;

    NSMutableDictionary * invocations;
}

@property (nonatomic, copy, readonly) NSString * baseUrl;

#pragma mark Instantiation

+ (id)gravatarWithBaseUrlString:(NSString *)baseUrlString
                       delegate:(id<GravatarDelegate>)aDelegate;
- (id)initWithBaseUrlString:(NSString *)baseUrlString
                   delegate:(id<GravatarDelegate>)aDelegate;

#pragma mark Fetching avatars

- (void)fetchAvatarForEmailAddress:(NSString *)emailAddress;

@end
