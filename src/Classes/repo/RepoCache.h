//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoCacheReader.h"
#import "RepoCacheSetter.h"

@interface RepoCache : NSObject <RepoCacheReader, RepoCacheSetter>
{
    NSDictionary * allRepos;
    NSDictionary * allPrimaryUserRepos;
}

@end
