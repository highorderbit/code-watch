//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GravatarServiceFactory.h"
#import "GravatarService.h"

@implementation GravatarServiceFactory

- (void)dealloc
{
    [configReader release];
    [super dealloc];
}

- (GravatarService *)create
{
    NSString * baseUrl = [configReader valueForKey:@"GravatarApiBaseUrl"];
    return [[GravatarService alloc] initWithGravatarBaseUrlString:baseUrl];
}

@end
