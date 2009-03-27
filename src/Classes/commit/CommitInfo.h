//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitInfo : NSObject <NSCopying>
{
    NSDictionary * details;
    NSDictionary * changesets;
}

@property (nonatomic, readonly, copy) NSDictionary * details;
@property (nonatomic, readonly, copy) NSDictionary * changesets;

#pragma mark Initialization

- (id)initWithDetails:(NSDictionary *)someDetails;
- (id)initWithDetails:(NSDictionary *)someDetails
           changesets:(NSDictionary *)someChangesets;

@end
