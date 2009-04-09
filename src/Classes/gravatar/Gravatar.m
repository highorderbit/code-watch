//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "Gravatar.h"
#import "WebServiceApi.h"
#import "NSString+CryptoAdditions.h"
#import "NSDictionary+NonRetainedKeyAdditions.h"
#import "NSError+InstantiationAdditions.h"
#import "NSString+UrlAdditions.h"

@implementation Gravatar

@synthesize baseUrl;

- (void)dealloc
{
    [delegate release];
    [baseUrl release];
    [api release];
    [invocations release];
    [super dealloc];
}

#pragma mark Instantiation

+ (id)gravatarWithBaseUrlString:(NSString *)baseUrlString
                       delegate:(id<GravatarDelegate>)aDelegate
{
    return [[[[self class] alloc]
        initWithBaseUrlString:baseUrlString delegate:aDelegate] autorelease];
}

- (id)initWithBaseUrlString:(NSString *)baseUrlString
                   delegate:(id<GravatarDelegate>)aDelegate
{
    if (self = [super init]) {
        baseUrl = [baseUrlString copy];
        delegate = [aDelegate retain];
        api = [[WebServiceApi alloc] initWithDelegate:self];
        invocations = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Fetch avatars

- (void)fetchAvatarForEmailAddress:(NSString *)emailAddress
{
    [self fetchAvatarForEmailAddress:emailAddress defaultAvatarUrl:nil];
}

- (void)fetchAvatarForEmailAddress:(NSString *)emailAddress
                  defaultAvatarUrl:(NSString *)defaultAvatarUrl
{
    NSString * hashedEmailAddress = [emailAddress md5Hash];

    NSString * urlString =
        defaultAvatarUrl ?
        [NSString stringWithFormat:@"%@%@.jpg?d=%@", baseUrl,
        hashedEmailAddress, [defaultAvatarUrl urlEncodedString]] :
        [NSString stringWithFormat:@"%@%@.jpg", baseUrl, hashedEmailAddress];

    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    SEL sel = @selector(handleAvatarResponse:toRequest:emailAddress:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];

    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:sel];
    [inv setArgument:&emailAddress atIndex:4];
    [inv retainArguments];

    [invocations setObject:inv forNonRetainedKey:req];

    [api sendRequest:req];
}

#pragma mark Processing responses

- (void)handleAvatarResponse:(NSData *)response
                   toRequest:(NSURLRequest *)request
                emailAddress:(NSString *)emailAddress
{
    if ([response isKindOfClass:[NSError class]]) {
        NSError * error = (NSError *) response;
        [delegate failedToFetchAvatarForEmailAddress:emailAddress error:error];
    } else {
        UIImage * avatar = [UIImage imageWithData:response];
        if (avatar)
            [delegate avatar:avatar fetchedForEmailAddress:emailAddress];
        else {
            NSError * error = [NSError errorWithLocalizedDescription:
                NSLocalizedString(@"gravatar.parse.failed", @"")];
            [delegate failedToFetchAvatarForEmailAddress:emailAddress
                                                   error:error];
        }
    }
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

- (void)request:(NSURLRequest *)request
    didFailWithError:(NSError *)error
{
    NSInvocation * invocation = [invocations objectForNonRetainedKey:request];
    [invocation setArgument:&error atIndex:2];
    [invocation setArgument:&request atIndex:3];

    [invocation invoke];

    [invocations removeObjectForNonRetainedKey:request];
}

@end
