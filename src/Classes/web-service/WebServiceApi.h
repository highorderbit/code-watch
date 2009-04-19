//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceApiDelegate.h"
#import "NSURLRequest+WebServiceApiAdditions.h"

@interface WebServiceApi : NSObject
{
    id<WebServiceApiDelegate> delegate;

    NSMutableDictionary * requests;
    NSMutableDictionary * connectionData;
    NSMutableDictionary * tokens;
}

#pragma mark Instantiation

- (id)initWithDelegate:(id<WebServiceApiDelegate>)aDelegate;

#pragma mark Sending requests

- (NSInteger)sendRequest:(NSURLRequest *)request;
- (BOOL)cancelRequest:(NSInteger)token;

@end
