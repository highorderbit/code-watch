//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ContactCache.h"

@implementation ContactCache

@synthesize recordIds;

- (void)dealloc
{
    [recordIds release];
    [super dealloc];
}

- (void)awakeFromNib
{
    recordIds = [[NSMutableDictionary dictionary] retain];
}

#pragma mark ContactCacheReader implementation

- (ABRecordID)recordIdForUser:(NSString *)username
{
    NSNumber * recordId = [recordIds objectForKey:username];
    
    return recordId ? [recordId intValue] : kABRecordInvalidID;
}

#pragma mark ContactCacheSetter implementation

- (void)setRecordId:(ABRecordID)recordId forUser:(NSString *)username
{
    [recordIds setObject:[NSNumber numberWithInteger:recordId] forKey:username];
}

@end
