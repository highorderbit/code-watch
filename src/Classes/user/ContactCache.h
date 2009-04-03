//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactCacheReader.h"
#import "ContactCacheSetter.h"

@interface ContactCache : NSObject <ContactCacheReader, ContactCacheSetter>
{
    NSMutableDictionary * recordIds;
}

@end
