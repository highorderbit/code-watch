//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubApiParser.h"
#import "JsonGitHubApiParserImpl.h"

@interface GitHubApiParser (Private)
+ (NSObject<GitHubApiParserImpl> *)parserImplForFormat:(GitHubApiFormat)format;
@end

@implementation GitHubApiParser

@synthesize apiFormat;

+ (id)parserWithApiFormat:(GitHubApiFormat)format
{
    return [[[[self class] alloc] initWithApiFormat:format] autorelease];
}

- (id)initWithApiFormat:(GitHubApiFormat)format
{
    if (self = [super init]) {
        apiFormat = format;
        impl = [[[self class] parserImplForFormat:format] retain];
    }

    return self;
}

#pragma mark Parsing GitHub API responses

- (NSDictionary *)parseResponse:(NSData *)response
{
    return [impl parseResponse:response];
}

#pragma mark Helper methods

+ (NSObject<GitHubApiParserImpl> *)parserImplForFormat:(GitHubApiFormat)format
{
    NSObject<GitHubApiParserImpl> * impl;

    switch (format) {
        case JsonApiFormat:
            impl = [[JsonGitHubApiParserImpl alloc] init];
            break;
    }

    return [impl autorelease];
}

@end