//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarDelegate.h"
#import "GravatarServiceDelegate.h"

@class Gravatar;

@interface GravatarService : NSObject <GravatarDelegate>
{
    id<GravatarServiceDelegate> delegate;

    Gravatar * gravatar;
}

@property (nonatomic, retain) id<GravatarServiceDelegate> delegate;

#pragma mark Initialization

- (id)initWithGravatarBaseUrlString:(NSString *)baseUrl;

#pragma mark Fetching avatars

- (void)fetchAvatarForEmailAddress:(NSString *)emailAddress;

@end
