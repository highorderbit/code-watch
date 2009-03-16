//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GitHubApiRequest;

@protocol GitHubApiDelegate

- (void)request:(GitHubApiRequest *)request
    didCompleteWithResponse:(NSData *)response;
- (void)request:(GitHubApiRequest *)request
    didFailWithError:(NSError *)error;

@end