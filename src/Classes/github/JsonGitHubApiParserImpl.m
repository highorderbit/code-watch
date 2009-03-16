//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "JsonGitHubApiParserImpl.h"
#import "NSString+NSDataAdditions.h"
#import <JSON/JSON.h>

@implementation JsonGitHubApiParserImpl

- (NSArray *)parseResponse:(NSData *)response
{
    return [[NSString stringWithUTF8EncodedData:response] JSONValue];
}

@end