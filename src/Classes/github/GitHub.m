//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHub.h"
#import "WebServiceApi.h"
#import "GitHubApiParser.h"

#import "NSString+NSDataAdditions.h"
#import "NSDictionary+NonRetainedKeyAdditions.h"
#import "NSError+InstantiationAdditions.h"

@interface GitHub (Private)

- (NSInvocation *)invocationForRequest:(NSURLRequest *)request;
- (void)setInvocation:(NSInvocation *)invocation
           forRequest:(NSURLRequest *)request;
- (void)removeInvocationForRequest:(NSURLRequest *)request;

- (NSString *)baseApiUrlForVersion:(NSUInteger)apiVersion;
- (void)setDelegate:(id<GitHubDelegate>)aDelegate;
- (void)setBaseUrl:(NSURL *)url;
- (void)setApi:(WebServiceApi *)anApi;
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
        [self setApi:
            [[[WebServiceApi alloc] initWithDelegate:self] autorelease]];
        [self setParser:[GitHubApiParser parserWithApiFormat:format]];

        apiFormat = format;

        requests = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Working with repositories

- (void)fetchInfoForUsername:(NSString *)username token:(NSString *)token
{
    NSString * url =
        [NSString stringWithFormat:@"%@/%@", [self baseApiUrlForVersion:1],
        username];

    NSDictionary * args =
        token ?
        [NSDictionary dictionaryWithObjectsAndKeys:
        username, @"login", token, @"token", nil] :
        nil;

    NSURLRequest * req =
        [NSURLRequest requestWithBaseUrlString:url getArguments:args];

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
    NSString * url =
        [NSString stringWithFormat:@"%@/%@/%@/commits/master",
        [self baseApiUrlForVersion:1], username, repo];

    NSDictionary * args =
        token ?
        [NSDictionary dictionaryWithObjectsAndKeys:
        username, @"login", token, @"token", nil] :
        nil;

    NSURLRequest * req =
        [NSURLRequest requestWithBaseUrlString:url getArguments:args];

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
    NSString * url =
        [NSString stringWithFormat:@"%@/%@/%@/commit/%@",
        [self baseApiUrlForVersion:1], username, repo, commitKey];

    NSDictionary * args =
        token ?
        [NSDictionary dictionaryWithObjectsAndKeys:
        username, @"login", token, @"token", nil] :
        nil;

    NSURLRequest * req =
        [NSURLRequest requestWithBaseUrlString:url getArguments:args];

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

#pragma mark Fetching followers

- (void)fetchFollowingForUsername:(NSString *)username
{
    NSString * url =
        [NSString stringWithFormat:@"%@/user/show/%@/following",
        [self baseApiUrlForVersion:2], username];

    NSURLRequest * req =
        [NSURLRequest requestWithBaseUrlString:url getArguments:nil];

    SEL sel = @selector(handleFollowingResponse:toRequest:username:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&username atIndex:4];
    [inv retainArguments];

    [self setInvocation:inv forRequest:req];

    [api sendRequest:req];
}

- (void)followUsername:(NSString *)followee
              follower:(NSString *)follower
                 token:(NSString *)token
{
    NSString * url =
        [NSString stringWithFormat:@"%@/user/follow/%@",
        [self baseApiUrlForVersion:2], followee];

    NSString * requestString =
        [NSString stringWithFormat:@"login=%@&token=%@", follower, token];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];

    SEL sel =
        @selector(handleFollowResponse:toRequest:followee:follower:token:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&followee atIndex:4];
    [inv setArgument:&follower atIndex:5];
    [inv setArgument:&token atIndex:6];
    [inv retainArguments];

    [self setInvocation:inv forRequest:req];

    [api sendRequest:req];
}

- (void)unfollowUsername:(NSString *)followee
                follower:(NSString *)follower
                   token:(NSString *)token
{
    NSString * url =
        [NSString stringWithFormat:@"%@/user/unfollow/%@",
        [self baseApiUrlForVersion:2], followee];

    NSString * requestString =
        [NSString stringWithFormat:@"login=%@&token=%@", follower, token];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];

    SEL sel =
        @selector(handleUnfollowResponse:toRequest:followee:follower:token:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&followee atIndex:4];
    [inv setArgument:&follower atIndex:5];
    [inv setArgument:&token atIndex:6];
    [inv retainArguments];

    [self setInvocation:inv forRequest:req];

    [api sendRequest:req];
}

#pragma mark Searching GitHub

- (void)search:(NSString *)searchString
{
    NSString * url = [NSString stringWithFormat:@"%@/search/%@",
        [self baseApiUrlForVersion:1], searchString];

    NSURLRequest * req =
        [NSURLRequest requestWithBaseUrlString:url getArguments:nil];

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

- (void)request:(NSURLRequest *)request
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

- (void)request:(NSURLRequest *)request
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
                     toRequest:(NSURLRequest *)request
                      username:(NSString *)username
                         token:(NSString *)token
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate failedToFetchInfoForUsername:username error:response];
        return;
    }

    NSDictionary * details = [parser parseResponse:response];
    if (details) {
        [delegate userInfo:details fetchedForUsername:username token:token];
        NSLog(@"Have user details: '%@'.", details);
    } else {  // parsing failed
        NSLog(@"Failed to parse user info response for username: '%@', "
            "token: '%@', response: '%@'.", username, token,
            [NSString stringWithUTF8EncodedData:response]);
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToFetchInfoForUsername:username error:err];
    }
}

- (void)handleRepoResponse:(id)response
                 toRequest:(NSURLRequest *)request
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
    if (details) {
       [delegate
            commits:details fetchedForRepo:repo username:username token:token];
        NSLog(@"Have repo details: '%@'", details);
    } else {
        NSLog(@"Failed to parse repo info response for username: '%@', repo: "
            "'%@', token: '%@', response: '%@'.", username, repo, token,
            [NSString stringWithUTF8EncodedData:response]);
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToFetchInfoForUsername:username error:err];
    }
}

- (void)handleCommitResponse:(id)response
                   toRequest:(NSURLRequest *)request
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
    if (details) {
        [delegate commitDetails:details fetchedForCommit:commitKey
           repo:repo username:username token:token];
        NSLog(@"Have commit details: '%@'", details);
    } else {
        NSLog(@"Failed to parse commit info response for username: '%@', repo: "
            "'%@', commit key: '%@', token: '%@', response: '%@'.", username,
            repo, commitKey, token,
            [NSString stringWithUTF8EncodedData:response]);
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToFetchInfoForCommit:commitKey repo:repo
            username:username token:token error:err];
    }
}

- (void)handleFollowingResponse:(id)response
                      toRequest:(NSURLRequest *)request
                       username:(NSString *)username
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate failedToFetchFollowingForUsername:username error:response];
        return;
    }

    NSDictionary * following = [parser parseResponse:response];
    if (following) {

        // following could contain an error.
        if ([following objectForKey:@"error"]) {
            NSString * msg =
                [[[following objectForKey:@"error"]
                objectAtIndex:0]
                objectForKey:@"error"];

            NSLog(@"Failed to retrieve response for username: '%@', "
                "error: '%@'.", username, following);

            NSError * err = [NSError errorWithLocalizedDescription:msg];
            [delegate failedToFetchFollowingForUsername:username error:err];
        } else {
            [delegate following:following fetchedForUsername:username];
            NSLog(@"Have following for username '%@': '%@'", username,
                following);
        }
    } else {
        NSLog(@"Failed to parse following response for username: '%@', "
            "response: '%@'.", username,
            [NSString stringWithUTF8EncodedData:response]);
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToFetchFollowingForUsername:username error:err];
    }
}

- (void)handleFollowResponse:(id)response
                   toRequest:(NSURLRequest *)request
                    followee:(NSString *)followee
                    follower:(NSString *)follower
                       token:(NSString *)token
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate
            failedToFollowUsername:followee follower:follower token:token
            error:response];
        return;
    }

    NSDictionary * following = [parser parseResponse:response];

    if (following) {
        // TODO: Add handling for a GitHub error received in the response.
        [delegate username:follower isFollowing:followee token:token];
        NSLog(@"'%@' is now following '%@'. Following: '%@'.", follower,
            followee, following);
    } else {
        NSLog(@"Failed to parse follow response for follower: '%@', "
            "followee: '%@', token: '%@', response: '%@'.", follower,
            followee, token, [NSString stringWithUTF8EncodedData:response]);
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate
            failedToFollowUsername:followee follower:follower token:token
            error:err];
    }
}

- (void)handleUnfollowResponse:(id)response
                     toRequest:(NSURLRequest *)request
                      followee:(NSString *)followee
                      follower:(NSString *)follower
                         token:(NSString *)token
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate
            failedToUnfollowUsername:followee follower:follower token:token
            error:response];
        return;
    }

    NSDictionary * following = [parser parseResponse:response];
    if (following) {
        // TODO: Add handling for a GitHub error received in the response.
        NSLog(@"'%@' is no longer following '%@'. Following: '%@'.", follower,
            followee, following);
        [delegate username:follower didUnfollow:followee token:token];
    } else {
        NSLog(@"Failed to parse unfollow response for follower: '%@', "
            "followee: '%@', token: '%@', response: '%@'.", follower,
            followee, token, [NSString stringWithUTF8EncodedData:response]);
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate
            failedToUnfollowUsername:followee follower:follower token:token
            error:err];
    }
}

- (void)handleSearchResults:(id)response
                  toRequest:(NSURLRequest *)request
               searchString:(NSString *)searchString
{
    if ([response isKindOfClass:[NSError class]]) {
        [delegate failedToSearchForString:searchString error:response];
        return;
    }

    NSDictionary * results = [parser parseResponse:response];

    if (results) {
        NSLog(@"Search for '%@' returned results: '%@'.", searchString,
            results);
        [delegate searchResults:results foundForSearchString:searchString];
    } else {
        NSLog(@"Failed to parse search results for search string: '%@', "
            "response: '%@'.", searchString,
            [NSString stringWithUTF8EncodedData:response]);
        NSString * desc = NSLocalizedString(@"github.parse.failed.desc", @"");
        NSError * err = [NSError errorWithLocalizedDescription:desc];
        [delegate failedToSearchForString:searchString error:err];
    }
}

#pragma mark Functions to help with building API URLs

- (NSString *)baseApiUrlForVersion:(NSUInteger)apiVersion
{
    //
    // GitHub API URL format is:
    //     http://github.com/api/version/format/args...
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

    return [NSString stringWithFormat:@"%@v%d/%@", baseUrl, apiVersion,
        responseFormat];
}

#pragma mark Tracking requests

- (NSInvocation *)invocationForRequest:(NSURLRequest *)request
{
    return [requests objectForNonRetainedKey:request];
}

- (void)setInvocation:(NSInvocation *)invocation
           forRequest:(NSURLRequest *)request
{
    [requests setObject:invocation forNonRetainedKey:request];
}

- (void)removeInvocationForRequest:(NSURLRequest *)request
{
    [requests removeObjectForNonRetainedKey:request];
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

- (void)setApi:(WebServiceApi *)anApi
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
