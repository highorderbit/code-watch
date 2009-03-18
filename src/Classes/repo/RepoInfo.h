//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepoInfo : NSObject <NSCopying>
{
    NSDictionary * details;
}

@property (nonatomic, copy, readonly) NSDictionary * details;

@end
