//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitHubApiParserImpl

- (NSArray *)parseResponse:(NSData *)response;

@end