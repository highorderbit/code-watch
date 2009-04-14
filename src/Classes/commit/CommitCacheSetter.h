//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitInfo.h"

@protocol CommitCacheSetter

- (void)setCommit:(CommitInfo *)commitInfo forKey:(NSString *)key;
- (void)clear;

@end
