//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigReader.h"

@class GravatarService;

@interface GravatarServiceFactory : NSObject
{
    IBOutlet NSObject<ConfigReader> * configReader;
}

- (GravatarService *)create;

@end
