//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubApi.h"
#import "GitHubApiRequest.h"

@interface GitHubApi (Private)
- (void)trackConnection:(NSURLConnection *)conn
             forRequest:(GitHubApiRequest *)req;
- (NSMutableData *)dataForConnection:(NSURLConnection *)conn;
- (GitHubApiRequest *)gitHubApiRequestForConnection:(NSURLConnection *)conn;
- (void)cleanUpConnection:(NSURLConnection *)conn;
+ (NSValue *)keyForConnection:(NSURLConnection *)conn;
+ (NSURLConnection *)connectionFromKey:(NSValue *)key;
- (void)setDelegate:(id<GitHubApiDelegate>)aDelegate;
@end

@implementation GitHubApi

- (void)dealloc
{
    [requests release];
    [connectionData release];
    [super dealloc];
}

- (id)initWithDelegate:(id<GitHubApiDelegate>)aDelegate
{
    if (self = [super init]) {
        [self setDelegate:aDelegate];
        requests = [[NSMutableDictionary alloc] init];
        connectionData = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)sendRequest:(GitHubApiRequest *)request
{
    NSLog(@"Sending request to: '%@'.", request.urlRequest);

    NSURLRequest * req = request.urlRequest;
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:req
                                                             delegate:self
                                                        startImmediately:YES];

    [self trackConnection:conn forRequest:request];
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData * mutableData = [self dataForConnection:connection];
    [mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    GitHubApiRequest * request = [self gitHubApiRequestForConnection:conn];
    NSMutableData * response = [self dataForConnection:conn];

    [delegate request:request didCompleteWithResponse:response];

    [self cleanUpConnection:conn];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    GitHubApiRequest * request = [self gitHubApiRequestForConnection:conn];

    [delegate request:request didFailWithError:error];

    [self cleanUpConnection:conn];
}

#pragma mark Track connections

- (void)trackConnection:(NSURLConnection *)conn
             forRequest:(GitHubApiRequest *)request
{
    NSValue * key = [[self class] keyForConnection:conn];
    NSMutableData * data = [NSMutableData data];

    [requests setObject:request forKey:key];
    [connectionData setObject:data forKey:key];
}

- (NSMutableData *)dataForConnection:(NSURLConnection *)conn
{
    NSValue * key = [[self class] keyForConnection:conn];
    return [connectionData objectForKey:key];
}

- (GitHubApiRequest *)gitHubApiRequestForConnection:(NSURLConnection *)conn
{
    NSValue * key = [[self class] keyForConnection:conn];
    return [requests objectForKey:key];
}

- (void)cleanUpConnection:(NSURLConnection *)conn
{
    NSValue * key = [[self class] keyForConnection:conn];

    [requests removeObjectForKey:key];
    [connectionData removeObjectForKey:key];
    
    [conn autorelease];
}

// TODO: deleting a connection needs to release it

+ (NSValue *)keyForConnection:(NSURLConnection *)conn
{
    return [NSValue valueWithNonretainedObject:conn];
}

+ (NSURLConnection *)connectionFromKey:(NSValue *)key
{
    return [key nonretainedObjectValue];
}

#pragma mark Accessors

- (void)setDelegate:(id<GitHubApiDelegate>)aDelegate
{
    // We don't retain our delegate. We don't own it and it is expected to
    // be valid for the duration of its use by this class.
    delegate = aDelegate;
}

@end
