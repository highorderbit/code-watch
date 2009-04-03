//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/ABNewPersonViewController.h>

@protocol ContactCacheReader

@property (readonly, copy) NSMutableDictionary * recordIds;
- (ABRecordID)recordIdForUser:(NSString *)username;

@end
