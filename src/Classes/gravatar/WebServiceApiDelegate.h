//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebServiceApiDelegate;

@protocol WebServiceApiDelegate <NSObject>

- (void)request:(NSURLRequest *)request
    didCompleteWithResponse:(NSData *)response;
- (void)request:(NSURLRequest *)request
    didFailWithError:(NSError *)error;

@end
