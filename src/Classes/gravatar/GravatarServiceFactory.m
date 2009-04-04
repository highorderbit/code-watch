//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GravatarServiceFactory.h"
#import "AvatarCache.h"
#import "GravatarService.h"

@implementation GravatarServiceFactory

- (void)dealloc
{
    [configReader release];
    [avatarCache release];
    [super dealloc];
}

- (GravatarService *)createGravatarService
{
    NSString * baseUrl = [configReader valueForKey:@"GravatarApiBaseUrl"];
    return [[GravatarService alloc] initWithGravatarBaseUrlString:baseUrl
                                                avatarCacheSetter:avatarCache];
}

@end
