//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@protocol GitHubDelegate

- (void)username:(NSString *)username hasInfo:(UserInfo *)info;

@end
