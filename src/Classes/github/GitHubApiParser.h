//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubApiFormat.h"
#import "GitHubApiParserImpl.h"

@interface GitHubApiParser : NSObject
{
    GitHubApiFormat apiFormat;

    NSObject<GitHubApiParserImpl> * impl;
}

@property (assign, readonly) GitHubApiFormat apiFormat;

#pragma mark Instantiation

+ (id)parserWithApiFormat:(GitHubApiFormat)format;

- (id)initWithApiFormat:(GitHubApiFormat)format;

#pragma mark Parsing GitHub API responses

- (NSDictionary *)parseResponse:(NSData *)response;

@end
