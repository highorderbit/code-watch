//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarDelegate.h"
#import "GravatarServiceDelegate.h"
#import "AvatarCacheSetter.h"

@class Gravatar;

@interface GravatarService : NSObject <GravatarDelegate>
{
    id<GravatarServiceDelegate> delegate;

    id<AvatarCacheSetter> avatarCacheSetter;

    Gravatar * gravatar;
}

@property (nonatomic, retain) id<GravatarServiceDelegate> delegate;

#pragma mark Initialization

- (id)initWithGravatarBaseUrlString:(NSString *)baseUrl
                  avatarCacheSetter:(id<AvatarCacheSetter>)anAvatarCacheSetter;


#pragma mark Fetching avatars

- (void)fetchAvatarForEmailAddress:(NSString *)emailAddress;

@end
