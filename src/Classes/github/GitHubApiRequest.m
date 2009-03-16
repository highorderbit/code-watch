//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubApiRequest.h"
#import "NSString+UrlAdditions.h"

@interface GitHubApiRequest (Private)
- (void)setUrl:(NSURL *)url;
- (void)setArguments:(NSDictionary *)args;
- (void)setUrlRequest:(NSURLRequest *)req;
@end

@implementation GitHubApiRequest

@synthesize baseUrl, arguments, urlRequest;

+ (id)requestWithBaseUrl:(NSURL *)url
{
    return [[[[self class] alloc] initWithBaseUrl:url] autorelease];
}

+ (id)requestWithBaseUrl:(NSURL *)url arguments:(NSDictionary *)args
{
    return [[[[self class] alloc] initWithBaseUrl:url arguments:args]
        autorelease];
}

- (id)initWithBaseUrl:(NSURL *)url
{
    return [self initWithBaseUrl:url arguments:nil];
}

- (id)initWithBaseUrl:(NSURL *)url arguments:(NSDictionary *)args
{
    if (self = [super init]) {
        [self setUrl:url];
        [self setArguments:args];
    }

    return self;
}

- (NSURLRequest *)urlRequest
{
    if (urlRequest == nil) {
        NSURL * url = baseUrl;

        // append arguments to the URL string if there are any
        if (arguments && arguments.count > 0) {
            NSMutableString * s = [[baseUrl absoluteString] mutableCopy];

            [s appendString:@"?"];
            for (id key in arguments)
                [s appendFormat:@"%@=%@&", key, [arguments objectForKey:key]];

            url = [NSURL URLWithString:[s urlEncodedString]];
        }

        NSURLRequest * req =
            [[NSURLRequest alloc]
             initWithURL:url
             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
         timeoutInterval:60.0];  // 60 secs is the default per the documentation

        [self setUrlRequest:req];
    }

    return urlRequest;
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    GitHubApiRequest * req =
        [[[self class] allocWithZone:zone]
         initWithBaseUrl:baseUrl arguments:arguments];

    [req setUrlRequest:urlRequest];

    return req;
}


#pragma mark Accessors

- (void)setUrl:(NSURL *)aUrl
{
    NSURL * tmp = [aUrl copy];
    [baseUrl release];
    baseUrl = tmp;
}

- (void)setArguments:(NSDictionary *)args
{
    NSDictionary * tmp = [args copy];
    [arguments release];
    arguments = tmp;
}

- (void)setUrlRequest:(NSURLRequest *)req
{
    NSURLRequest * tmp = [req copy];
    [urlRequest release];
    urlRequest = tmp;
}

@end
