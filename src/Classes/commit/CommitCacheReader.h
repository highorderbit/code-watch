//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitInfo.h"

@protocol CommitCacheReader

@property (readonly, copy) NSDictionary * allCommits;
- (CommitInfo *)commitWithKey:(NSString *)key;

@end
