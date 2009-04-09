//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GravatarService.h"
#import "Gravatar.h"
#import "UIApplication+NetworkActivityIndicatorAdditions.h"

@implementation GravatarService

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [avatarCacheSetter release];
    [gravatar release];
    [defaultAvatarUrl release];
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithGravatarBaseUrlString:(NSString *)baseUrl
                   defaultAvatarUrl:(NSString *)aDefaultAvatarUrl
                  avatarCacheSetter:(id<AvatarCacheSetter>)anAvatarCacheSetter
{
    if (self = [super init]) {
        gravatar = [[Gravatar alloc]
            initWithBaseUrlString:baseUrl delegate:self];
        defaultAvatarUrl = [aDefaultAvatarUrl copy];
        avatarCacheSetter = [anAvatarCacheSetter retain];
    }

    return self;
}

#pragma mark Fetching avatars

- (void)fetchAvatarForEmailAddress:(NSString *)emailAddress
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    [gravatar fetchAvatarForEmailAddress:emailAddress
                        defaultAvatarUrl:defaultAvatarUrl];
}

#pragma mark GravatarDelegate implementation

- (void)avatar:(UIImage *)avatar
    fetchedForEmailAddress:(NSString *)emailAddress
{
    [avatarCacheSetter setAvatar:avatar forEmailAddress:emailAddress];
    [delegate avatar:avatar fetchedForEmailAddress:emailAddress];

    [[UIApplication sharedApplication] networkActivityDidFinish];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
    error:(NSError *)error
{
    [delegate failedToFetchAvatarForEmailAddress:emailAddress error:error];

    [[UIApplication sharedApplication] networkActivityDidFinish];
}

@end
