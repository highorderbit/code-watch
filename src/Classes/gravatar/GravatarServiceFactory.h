//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigReader.h"

@class AvatarCache, GravatarService;

@interface GravatarServiceFactory : NSObject
{
    IBOutlet NSObject<ConfigReader> * configReader;
    IBOutlet AvatarCache * avatarCache;
}

- (GravatarService *)createGravatarService;

@end
