//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCopying>
{
    NSDictionary * details;
    NSArray * repoKeys;
}

@property (readonly, copy) NSDictionary * details;
@property (readonly, copy) NSArray * repoKeys;

- (id)initWithDetails:(NSDictionary *)someDetails
    repoKeys:(NSArray *)someRepoKeys;

@end
