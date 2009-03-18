//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepoInfo : NSObject <NSCopying>
{
    NSDictionary * details;
    NSArray * commitKeys;
}

@property (nonatomic, copy, readonly) NSDictionary * details;
@property (nonatomic, copy, readonly) NSArray * commitKeys;

#pragma mark Initialization

- (id)initWithDetails:(NSDictionary *)someDetails;
- (id)initWithDetails:(NSDictionary *)someDetails
           commitKeys:(NSArray *)someCommitKeys;

@end
