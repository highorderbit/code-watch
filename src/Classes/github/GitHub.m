//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHub.h"
#import "GitHubApi.h"
#import "GitHubApiRequest.h"
#import "GitHubApiParser.h"

#import "NSString+NSDataAdditions.h"
#import "NSError+InstantiationAdditions.h"

@interface GitHub (Private)
+ (GitHubApiRequest *)requestForUrl:(NSString *)urlString;
+ (GitHubApiRequest *)requestForUrl:(NSString *)urlString
                           username:(NSString *)username
                              token:(NSString *)token;

- (NSString *)baseApiUrl;
- (NSInvocation *)invocationForRequest:(GitHubApiRequest *)request;
- (void)setInvocation:(NSInvocation *)invocation
           forRequest:(GitHubApiRequest *)request;
- (void)removeInvocationForRequest:(GitHubApiRequest *)request;

+ (NSValue *)keyForRequest:(GitHubApiRequest *)request;
+ (GitHubApiRequest *)requestFromKey:(NSValue *)key;

- (void)setDelegate:(id<GitHubDelegate>)aDelegate;
- (void)setBaseUrl:(NSURL *)url;
- (void)setApi:(GitHubApi *)anApi;
- (void)setParser:(GitHubApiParser *)aParser;
@end

@implementation GitHub

@synthesize delegate, baseUrl, apiFormat, apiVersion;

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
              version:(GitHubApiVersion)version
             delegate:(id<GitHubDelegate>)aDelegate
{
    if (self = [super init]) {
        [self setDelegate:aDelegate];
        [self setBaseUrl:url];
        [self setApi:[[[GitHubApi alloc] initWithDelegate:self] autorelease]];
        [self setParser:[GitHubApiParser parserWithApiFormat:format]];

        apiFormat = format;
        apiVersion = version;

        requests = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Working with repositories

- (void)fetchInfoForUsername:(NSString *)username token:(NSString *)token
{
    NSURL * url =
        [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",
            [self baseApiUrl], username]];
    GitHubApiRequest * req;

    if (token) {
        NSDictionary * args = [NSDictionary dictionaryWithObjectsAndKeys:
            username, @"login", token, @"token", nil];
        req = [[GitHubApiRequest alloc] initWithBaseUrl:url arguments:args];
    } else
        req = [[GitHubApiRequest alloc] initWithBaseUrl:url];

    SEL sel = @selector(handleUserInfoResponse:toRequest:username:token:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&username atIndex:4];
    [inv setArgument:&token atIndex:5];
    [inv retainArguments];

    [self setInvocation:inv forRequest:req];

    [api sendRequest:req];
}

#pragma mark Fetch repo info

- (void)fetchInfoForRepo:(NSString *)repo
                username:(NSString *)username
                   token:(NSString *)token
{
    NSURL * url = [NSURL URLWithString:
        [NSString stringWithFormat:@"%@/%@/%@/commits/master",
        [self baseApiUrl], username, repo]];
    GitHubApiRequest * req;

    if (token) {
        NSDictionary * args = [NSDictionary dictionaryWithObjectsAndKeys:
            username, @"login", token, @"token", nil];
        req = [[GitHubApiRequest alloc] initWithBaseUrl:url arguments:args];
    } else
        req = [[GitHubApiRequest alloc] initWithBaseUrl:url];

    SEL sel = @selector(handleRepoResponse:toRequest:username:token:repo:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&username atIndex:4];
    [inv setArgument:&token atIndex:5];
    [inv setArgument:&repo atIndex:6];
    [inv retainArguments];

    [self setInvocation:inv forRequest:req];

    [api sendRequest:req];
}

- (void)fetchInfoForCommit:(NSString *)commitKey
                      repo:(NSString *)repo
                  username:(NSString *)username
                     token:(NSString *)token
{
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/%@/commit/%@",
        [self baseApiUrl], username, repo, commitKey];

    GitHubApiRequest * req =
        [[self class] requestForUrl:urlString username:username token:token];

    SEL sel =
        @selector(handleCommitResponse:toRequest:username:token:repo:commit:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&username atIndex:4];
    [inv setArgument:&token atIndex:5];
    [inv setArgument:&repo atIndex:6];
    [inv setArgument:&commitKey atIndex:7];
    [inv retainArguments];

    [self setInvocation:inv forRequest:req];

    [api sendRequest:req];
}

#pragma mark Searching GitHub

- (void)search:(NSString *)searchString
{
    NSString * urlString = [NSString stringWithFormat:@"%@/search/%@",
        [self baseApiUrl], searchString];

    GitHubApiRequest * req = [[self class] requestForUrl:urlString];

    SEL sel = @selector(handleSearchResults:toRequest:searchString:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&searchString atIndex:4];
    [inv retainArguments];

    [self setInvocation:inv forRequest:req];

    [api sendRequest:req];
}

#pragma mark GitHubApiDelegate functions

- (void)request:(GitHubApiRequest *)request
    didCompleteWithResponse:(NSData *)response
{
    NSLog(@"Request: '%@' succeeded: received %d bytes in response.", request,
        response.length);

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

    NSInvocation * invocation = [self invocationForRequest:request];
    [invocation setArgument:&error atIndex:2];
    [invocation setArgument:&request atIndex:3];

    [invocation invoke];

    [self removeInvocationForRequest:request];
}

#pragma mark Processing API responses

- (void)handleUserInfoResponse:(id)response
                     toRequest:(GitHubApiRequest *)request
                      username:(NSString *)username
                         token:(NSString *)token
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate failedToFetchInfoForUsername:username error:response];
        return;
    }

    NSDictionary * details = [parser parseResponse:response];
    NSLog(@"Have user details: '%@'.", details);

    if (details)
        [delegate userInfo:details fetchedForUsername:username token:token];
    else {  // parsing failed
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToFetchInfoForUsername:username error:err];
    }
}

- (void)handleRepoResponse:(id)response
                 toRequest:(GitHubApiRequest *)request
                  username:(NSString *)username
                     token:(NSString *)token
                      repo:(NSString *)repo
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate failedToFetchInfoForRepo:repo
                                  username:username
                                     error:response];
        return;
    }

    NSDictionary * details = [parser parseResponse:response];
    NSLog(@"Have repo details: '%@'", details);

    if (details)
       [delegate
            commits:details fetchedForRepo:repo username:username token:token];
    else {
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToFetchInfoForUsername:username error:err];
    }
}

- (void)handleCommitResponse:(id)response
                   toRequest:(GitHubApiRequest *)request
                    username:(NSString *)username
                       token:(NSString *)token
                        repo:(NSString *)repo
                      commit:(NSString *)commitKey
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate failedToFetchInfoForCommit:commitKey
                                        repo:repo
                                    username:username
                                       token:token
                                       error:response];
        return;
    }

    NSDictionary * details = [parser parseResponse:response];
    NSLog(@"Have commit details: '%@'", details);

    if (details)
        [delegate commitDetails:details fetchedForCommit:commitKey
           repo:repo username:username token:token];
    else {
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToFetchInfoForCommit:commitKey repo:repo
            username:username token:token error:err];
    }
}

- (void)handleSearchResults:(id)response
                  toRequest:(GitHubApiRequest *)request
               searchString:(NSString *)searchString
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate failedToSearchForString:searchString error:response];
        return;
    }

    NSDictionary * results = [parser parseResponse:response];
    NSLog(@"Search for '%@' returned results: '%@'.", searchString, results);

    if (results)
        [delegate searchResults:results foundForSearchString:searchString];
    else {
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToSearchForString:searchString error:err];
    }
}

#pragma mark Functions to help with building API URLs

+ (GitHubApiRequest *)requestForUrl:(NSString *)urlString
{
    return [[self class] requestForUrl:urlString username:nil token:nil];
}

+ (GitHubApiRequest *)requestForUrl:(NSString *)urlString
                           username:(NSString *)username
                              token:(NSString *)token
{
    NSURL * url = [NSURL URLWithString:urlString];

    GitHubApiRequest * req;
    if (token) {
        NSDictionary * args = [NSDictionary dictionaryWithObjectsAndKeys:
            username, @"login", token, @"token", nil];
        req = [[GitHubApiRequest alloc] initWithBaseUrl:url arguments:args];
    } else
        req = [[GitHubApiRequest alloc] initWithBaseUrl:url];
    
    return req;
}

- (NSString *)baseApiUrl
{
    //
    // GitHub API URL format is:
    //     http://github.com/api/version/format/username/
    //

    NSString * responseFormat;
    switch (apiFormat) {
        case JsonGitHubApiFormat:
            responseFormat = @"json";
            break;
        default:
            NSAssert1(0, @"Unknown GitHub API response format: %d.", apiFormat);
            break;
    }

    NSString * version;
    switch (apiVersion) {
        case GitHubApiVersion1:
            version = @"v1";
            break;
        default:
            NSAssert1(0, @"Unknown GitHub version: %d.", apiVersion);
            break;
    }

    return [NSString stringWithFormat:@"%@%@/%@",
        baseUrl, version, responseFormat];
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
