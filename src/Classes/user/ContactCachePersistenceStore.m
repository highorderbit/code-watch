//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <AddressBookUI/ABNewPersonViewController.h>
#import "ContactCachePersistenceStore.h"
#import "PListUtils.h"

@interface ContactCachePersistenceStore (Private)

+ (NSString *)plistName;

@end

@implementation ContactCachePersistenceStore

- (void)dealloc
{
    [cacheReader release];
    [cacheSetter release];
    [super dealloc];
}

#pragma mark PersistenceStore implementation

- (void) load
{
    NSDictionary * recordIds =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];

    for (NSString * username in [recordIds allKeys]) {
        ABRecordID recordId = [[recordIds objectForKey:username] intValue];
        [cacheSetter setRecordId:recordId forUser:username];
    }
}

- (void) save
{
    [PlistUtils saveDictionary:cacheReader.recordIds
        toPlist:[[self class] plistName]];
}

#pragma mark Static helpers

+ (NSString *)plistName
{
    return @"ContactCache";
}

@end
