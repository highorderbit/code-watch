//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "AvatarCache.h"
#import "RecentHistoryCache.h"

@implementation AvatarCache

- (id)init
{
    if (self = [super init])
        cache = [[RecentHistoryCache alloc] init];

    return self;
}

- (void)setAvatar:(UIImage *)avatar forEmailAddress:(NSString *)emailAddress
{
    [cache setObject:avatar forKey:emailAddress];
}

- (UIImage *)avatarForEmailAddress:(NSString *)emailAddress
{
    return [cache objectForKey:emailAddress];
}

@end
