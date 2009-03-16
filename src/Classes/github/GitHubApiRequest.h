//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitHubApiRequest : NSObject <NSCopying>
{
    NSURL * baseUrl;
    NSDictionary * arguments;

    NSURLRequest * urlRequest;  // The request with the base URL and arguments
                                // appended.
}

@property (copy, readonly) NSURL * baseUrl;
@property (copy, readonly) NSDictionary * arguments;
@property (copy, readonly) NSURLRequest * urlRequest;

#pragma mark Instantiation

+ (id)requestWithBaseUrl:(NSURL *)url;
+ (id)requestWithBaseUrl:(NSURL *)url arguments:(NSDictionary *)args;

- (id)initWithBaseUrl:(NSURL *)url;
- (id)initWithBaseUrl:(NSURL *)url arguments:(NSDictionary *)args;

#pragma mark Getting a URL request from the request URL and arguments

- (NSURLRequest *)urlRequest;

@end
