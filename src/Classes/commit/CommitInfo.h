//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitInfo : NSObject <NSCopying>
{
    NSDictionary * details;
}

@property (nonatomic, readonly, copy) NSDictionary * details;

#pragma mark Initialization

- (id)initWithDetails:(NSDictionary *)someDetails;

@end
