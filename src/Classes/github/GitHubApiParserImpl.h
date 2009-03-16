//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitHubApiParserImpl

- (NSDictionary *)parseResponse:(NSData *)response;

@end
