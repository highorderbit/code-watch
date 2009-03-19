//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitInfo.h"

@protocol CommitCacheReader

- (CommitInfo *)commitWithKey:(NSString *)key;
- (NSDictionary *)allCommits;

@end
