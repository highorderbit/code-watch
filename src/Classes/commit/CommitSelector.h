//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommitSelector

- (void)user:(NSString *)username didSelectCommit:(NSString *)commitKey
    fromRepo:(NSString *)repoName;

@end