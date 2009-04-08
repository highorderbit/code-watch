//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubNewsFeed.h"
#import "WebServiceApi.h"
#import "GitHubNewsFeedParser.h"

#import "NSError+InstantiationAdditions.h"
#import "NSDictionary+NonRetainedKeyAdditions.h"

@interface GitHubNewsFeed (Private)

- (void)fetchActivityFeedAtUrl:(NSString *)urlString
                      username:(NSString *)username;

@property (nonatomic, retain) id<GitHubNewsFeedDelegate> delegate;
@property (nonatomic, copy) NSString * baseUrl;

@end

@implementation GitHubNewsFeed

@synthesize delegate, baseUrl;

- (void)dealloc
{
    [delegate release];
    [baseUrl release];
    [api release];
    [parser release];
    [invocations release];
    [super dealloc];
}    

#pragma mark Initialization

- (id)initWithBaseUrl:(NSString *)aBaseUrl
             delegate:(id<GitHubNewsFeedDelegate>)aDelegate
{
    if (self = [super init]) {
        baseUrl = [aBaseUrl copy];
        delegate = [aDelegate retain];
        api = [[WebServiceApi alloc] initWithDelegate:self];
        parser = [[GitHubNewsFeedParser alloc] init];
        invocations = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Fetching RSS activity

- (void)fetchNewsFeedForPrimaryUser:(NSString *)username token:(NSString *)token
{
    NSString * url =
        [NSString stringWithFormat:@"%@%@.private.atom?token=%@",
        baseUrl, username, token];

    [self fetchActivityFeedAtUrl:url username:username];
}

- (void)fetchActivityFeedForUsername:(NSString *)username
{
    NSString * url =
        [NSString stringWithFormat:@"%@%@.atom", baseUrl, username];

    [self fetchActivityFeedAtUrl:url username:username];
}

- (void)fetchActivityFeedForUsername:(NSString *)username
                               token:(NSString *)token
{
    NSString * url =
        token ?
        [NSString stringWithFormat:@"%@%@.private.actor.atom?token=%@",
            baseUrl, username, token] :
        [NSString stringWithFormat:@"%@%@.atom", baseUrl, username];

    [self fetchActivityFeedAtUrl:url username:username];
}

#pragma mark WebServiceApiDelegate implementation

- (void)request:(NSURLRequest *)request
    didCompleteWithResponse:(NSData *)response
{
    NSInvocation * invocation = [invocations objectForNonRetainedKey:request];
    [invocation setArgument:&response atIndex:2];
    [invocation setArgument:&request atIndex:3];

    [invocation invoke];

    [invocations removeObjectForNonRetainedKey:request];
}

- (void)request:(NSURLRequest *)request didFailWithError:(NSError *)error
{
    NSInvocation * invocation = [invocations objectForNonRetainedKey:request];
    [invocation setArgument:&error atIndex:2];
    [invocation setArgument:&request atIndex:3];

    [invocation invoke];

    [invocations removeObjectForNonRetainedKey:request];
}

#pragma mark Processing responses

- (void)handleFeedResponse:(id)response
                 toRequest:(NSURLRequest *)request
                  username:(NSString *)username
{
    NSError * error = [response isKindOfClass:[NSError class]] ? response : nil;

    NSArray * rssActivity = error ? nil : [parser parseXml:response];
    if (!rssActivity)
        error = [NSError errorWithLocalizedDescription:
            NSLocalizedString(@"github.parse.failed.desc", @"")];

    if (rssActivity)
        [delegate newsFeed:rssActivity fetchedForUsername:username];
    else
        [delegate failedToFetchNewsFeedForUsername:username error:error];
}

#pragma mark Private helper methods

- (void)fetchActivityFeedAtUrl:(NSString *)urlString
                      username:(NSString *)username
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    SEL sel = @selector(handleFeedResponse:toRequest:username:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];

    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&username atIndex:4];
    [inv retainArguments];

    [invocations setObject:inv forNonRetainedKey:req];

    [api sendRequest:req];
}

@end
