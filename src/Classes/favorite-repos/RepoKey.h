//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepoKey : NSObject
{
    NSString * username;
    NSString * repoName;
}

- (id)initWithUsername:(NSString *)username repoName:(NSString *)repoName;

@property (copy, readonly) NSString * username;
@property (copy, readonly) NSString * repoName;

@end
