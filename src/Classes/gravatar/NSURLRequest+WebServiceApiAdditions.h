//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (WebServiceApiAdditions)

+ (id)requestWithBaseUrlString:(NSString *)baseUrlString
                  getArguments:(NSDictionary *)getArguments;
+ (id)requestWithBaseUrlString:(NSString *)baseUrlString
                  getArguments:(NSDictionary *)getArguments
                   cachePolicy:(NSURLRequestCachePolicy)cachePolicy
               timeoutInterval:(NSTimeInterval)timeoutInterval;

- (id)initWithBaseUrlString:(NSString *)baseUrlString
               getArguments:(NSDictionary *)getArguments;
- (id)initWithBaseUrlString:(NSString *)baseUrlString
               getArguments:(NSDictionary *)getArguments
                cachePolicy:(NSURLRequestCachePolicy)cachePolicy
            timeoutInterval:(NSTimeInterval)timeoutInterval;

@end