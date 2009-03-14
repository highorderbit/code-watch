//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSString * username;
    NSDictionary * details;
    NSArray * repos;
}

@property (readonly, copy) NSString * username;
@property (readonly, copy) NSDictionary * details;
@property (readonly, copy) NSArray * repos;

- (id)initWithUsername:(NSString *)aUsername
    details:(NSDictionary *)someDetails repos:(NSArray *)someRepos;

@end
