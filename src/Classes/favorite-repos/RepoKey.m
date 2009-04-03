//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "RepoKey.h"

@implementation RepoKey

@synthesize username;
@synthesize repoName;

- (void)dealloc
{
    [username release];
    [repoName release];
    [super dealloc];
}

+ (id)keyWithUsername:(NSString *)username repoName:(NSString *)repoName
{
    return [[[[self class] alloc] initWithUsername:username repoName:repoName]
        autorelease];
}

- (id)initWithUsername:(NSString *)aUsername repoName:(NSString *)aRepoName
{
    if (self = [super init]) {
        username = [aUsername copy];
        repoName = [aRepoName copy];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ / %@", username, repoName];
}

- (BOOL)isEqual:(id)anObject
{    
    RepoKey * anObjectAsRepoKey = (RepoKey *)anObject;

    return anObjectAsRepoKey && [username isEqual:anObjectAsRepoKey.username] &&
        [repoName isEqual:anObjectAsRepoKey.repoName];
}

@end
