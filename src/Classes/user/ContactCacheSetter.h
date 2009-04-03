//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/ABNewPersonViewController.h>

@protocol ContactCacheSetter

- (void)setRecordId:(ABRecordID)recordId forUser:(NSString *)username;

@end
