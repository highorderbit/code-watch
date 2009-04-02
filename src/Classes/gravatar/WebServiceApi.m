//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "WebServiceApi.h"

@interface WebServiceApi (Private)

- (NSInteger)trackConnection:(NSURLConnection *)conn
                  forRequest:(NSURLRequest *)request;
- (void)cleanUpConnection:(NSURLConnection *)conn;

- (NSMutableData *)dataForConnection:(NSURLConnection *)conn;
- (NSInteger)tokenForConnction:(NSURLConnection *)conn;
- (NSURLConnection *)connectionForToken:(NSInteger)target;
- (NSURLRequest *)requestForConnection:(NSURLConnection *)conn;

+ (NSValue *)keyForConnection:(NSURLConnection *)conn;
+ (NSURLConnection *)connectionFromKey:(NSValue *)key;

@end

@implementation WebServiceApi

- (void)dealloc
{
    [delegate release];

    [requests release];
    [connectionData release];
    [tokens release];

    [super dealloc];
}

#pragma mark Instantiation

- (id)initWithDelegate:(id<WebServiceApiDelegate>)aDelegate
{
    if (self = [super init]) {
        delegate = [aDelegate retain];

        requests = [[NSMutableDictionary alloc] init];
        connectionData = [[NSMutableDictionary alloc] init];
        tokens = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Sending requests

- (NSInteger)sendRequest:(NSURLRequest *)request
{
    NSLog(@"Sending request: '%@'.", request);

    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request
                                                             delegate:self
                                                     startImmediately:YES];

    NSInteger token = [self trackConnection:conn forRequest:request];

    [conn release];

    return token;
}

- (BOOL)cancelRequest:(NSInteger)token
{
    NSURLConnection * conn = [self connectionForToken:token];
    if (conn) {
        [conn cancel];
        [self cleanUpConnection:conn];
    }

    return !!conn;
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData * mutableData = [self dataForConnection:connection];
    [mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSURLRequest * request = [self requestForConnection:conn];
    NSMutableData * response = [self dataForConnection:conn];

    NSLog(@"Received %d bytes in response to request: '%@'.", [response length],
          request);

    [delegate request:request didCompleteWithResponse:response];

    [self cleanUpConnection:conn];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSURLRequest * request = [self requestForConnection:conn];

    NSLog(@"Request '%@' failed with error: '%@'.", request, error);

    [delegate request:request didFailWithError:error];

    [self cleanUpConnection:conn];
}


#pragma mark Track connections

- (NSInteger)trackConnection:(NSURLConnection *)conn
                  forRequest:(NSURLRequest *)request
{
    NSValue * key = [[self class] keyForConnection:conn];
    NSMutableData * data = [NSMutableData data];
    NSNumber * token = [NSNumber numberWithInteger:(NSInteger) conn];

    [requests setObject:request forKey:key];
    [connectionData setObject:data forKey:key];
    [tokens setObject:token forKey:key];

    return [token integerValue];
}

- (void)cleanUpConnection:(NSURLConnection *)conn
{
    NSValue * key = [[self class] keyForConnection:conn];

    [requests removeObjectForKey:key];
    [connectionData removeObjectForKey:key];
    [tokens removeObjectForKey:key];
}

- (NSMutableData *)dataForConnection:(NSURLConnection *)conn
{
    NSValue * key = [[self class] keyForConnection:conn];
    return [connectionData objectForKey:key];
}

- (NSInteger)tokenForConnction:(NSURLConnection *)conn
{
    NSValue * key = [[self class] keyForConnection:conn];
    return [[tokens objectForKey:key] integerValue];
}

- (NSURLConnection *)connectionForToken:(NSInteger)target
{
    for (NSNumber * token in tokens)
        if ([token integerValue] == target)
            return [tokens objectForKey:token];

    return nil;
}

- (NSURLRequest *)requestForConnection:(NSURLConnection *)conn
{
    NSValue * key = [[self class] keyForConnection:conn];
    return [requests objectForKey:key];
}

+ (NSValue *)keyForConnection:(NSURLConnection *)conn
{
    return [NSValue valueWithNonretainedObject:conn];
}

+ (NSURLConnection *)connectionFromKey:(NSValue *)key
{
    return [key nonretainedObjectValue];
}

@end
