//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHub.h"
#import "GitHubApi.h"
#import "GitHubApiRequest.h"

#import "UserInfo.h"

#import "NSString+NSDataAdditions.h"

@interface GitHub (Private)
- (NSURL *)baseApiUrlForUsername:(NSString *)username;
- (NSInvocation *)invocationForRequest:(GitHubApiRequest *)request;
- (void)setInvocation:(NSInvocation *)invocation
           forRequest:(GitHubApiRequest *)request;
- (void)removeInvocationForRequest:(GitHubApiRequest *)request;
+ (NSValue *)keyForRequest:(GitHubApiRequest *)request;
+ (GitHubApiRequest *)requestFromKey:(NSValue *)key;
+ (NSDictionary *)extractUserDetails:(NSDictionary *)githubInfo;
+ (NSArray *)extractRepos:(NSDictionary *)githubInfo;
- (void)setDelegate:(id<GitHubDelegate>)aDelegate;
- (void)setBaseUrl:(NSURL *)url;
- (void)setApi:(GitHubApi *)anApi;
- (void)setParser:(GitHubApiParser *)aParser;
@end

@implementation GitHub

@synthesize delegate, baseUrl, apiFormat;

- (void)dealloc
{
    [baseUrl release];
    [api release];
    [parser release];
    [requests release];
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithBaseUrl:(NSURL *)url
               format:(GitHubApiFormat)format
             delegate:(id<GitHubDelegate>)aDelegate
{
    if (self = [super init]) {
        [self setDelegate:aDelegate];
        [self setBaseUrl:url];
        [self setApi:[[[GitHubApi alloc] initWithDelegate:self] autorelease]];
        [self setParser:[GitHubApiParser parserWithApiFormat:format]];
        requests = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Working with repositories

- (void)fetchInfoForUsername:(NSString *)username
{
    NSURL * url = [self baseApiUrlForUsername:username];
    GitHubApiRequest * req = [[GitHubApiRequest alloc] initWithBaseUrl:url];

    SEL sel = @selector(handleUserInfoResponse:toRequest:forUsername:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&username atIndex:4];
    [inv retainArguments];

    [self setInvocation:inv forRequest:req];

    [api sendRequest:req];
}

#pragma mark GitHubApiDelegate functions

- (void)request:(GitHubApiRequest *)request
    didCompleteWithResponse:(NSData *)response
{
    NSInvocation * invocation = [self invocationForRequest:request];
    [invocation setArgument:&response atIndex:2];
    [invocation setArgument:&request atIndex:3];

    [invocation invoke];

    [self removeInvocationForRequest:request];
}

- (void)request:(GitHubApiRequest *)request
    didFailWithError:(NSError *)error
{
    NSLog(@"Request: '%@' failed: '%@'.", request, error);
}

#pragma mark Processing API responses

- (void)handleUserInfoResponse:(NSData *)response
                     toRequest:(GitHubApiRequest *)request
                   forUsername:(NSString *)username
{
    NSDictionary * info = [parser parseResponse:response];
    NSLog(@"Have user info: '%@'.", info);

    NSDictionary * userDetails = [[self class] extractUserDetails:info];
    NSArray * repos = [[self class] extractRepos:info];

    UserInfo * ui =
        [[UserInfo alloc] initWithDetails:userDetails
                                 repoKeys:repos];

    [delegate info:ui fetchedForUsername:username];

    [ui release];
}

#pragma mark Functions to help with building API URLs

- (NSURL *)baseApiUrlForUsername:(NSString *)username
{
    //
    // GitHub API URL format is:
    //     http://github.com/api/version/format/username/
    //

    static NSString * VERSION = @"v1";

    NSString * responseFormat;

    switch (apiFormat) {
        case JsonApiFormat:
            responseFormat = @"json";
            break;
        default:
            NSAssert1(0, @"Unknown GitHub API response format: %d.", apiFormat);
            break;
    }

    NSString * s = [NSString stringWithFormat:@"%@%@/%@/%@",
        baseUrl, VERSION, responseFormat, username];
    return [NSURL URLWithString:s];
}

#pragma mark Tracking requests

- (NSInvocation *)invocationForRequest:(GitHubApiRequest *)request
{
    NSValue * key = [[self class] keyForRequest:request];
    return [requests objectForKey:key];
}

- (void)setInvocation:(NSInvocation *)invocation
           forRequest:(GitHubApiRequest *)request
{
    NSValue * key = [[self class] keyForRequest:request];
    [requests setObject:invocation forKey:key];
}

- (void)removeInvocationForRequest:(GitHubApiRequest *)request
{
    NSValue * key = [[self class] keyForRequest:request];
    [requests removeObjectForKey:key];

    [request autorelease];
}

+ (NSValue *)keyForRequest:(GitHubApiRequest *)request
{
    return [NSValue valueWithNonretainedObject:request];
}

+ (GitHubApiRequest *)requestFromKey:(NSValue *)key
{
    return [key nonretainedObjectValue];
}

+ (NSDictionary *)extractUserDetails:(NSDictionary *)githubInfo
{
    NSMutableDictionary * info =
        [[[githubInfo objectForKey:@"user"] mutableCopy] autorelease];
    [info removeObjectForKey:@"repositories"];

    return info;
}

+ (NSArray *)extractRepos:(NSDictionary *)githubInfo
{
    return [[githubInfo objectForKey:@"user"] objectForKey:@"repositories"];
}

#pragma mark Accessors

- (void)setDelegate:(id<GitHubDelegate>)aDelegate
{
    // We don't retain our delegate. We don't own it and expect its
    // lifetime to span the use of this class.
    delegate = aDelegate;
}

- (void)setBaseUrl:(NSURL *)url
{
    [url retain];
    [baseUrl release];
    baseUrl = url;
}

- (void)setApi:(GitHubApi *)anApi
{
    [anApi retain];
    [api release];
    api = anApi;
}

- (void)setParser:(GitHubApiParser *)aParser
{
    [aParser retain];
    [parser release];
    parser = aParser;
}

@end
