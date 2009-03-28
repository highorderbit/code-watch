//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteReposPersistenceStore.h"
#import "PListUtils.h"

@interface FavoriteReposPersistenceStore (Private)

+ (NSString *)plistName;
+ (NSString *)repoKeySeparator;
+ (RepoKey *)repoKeyFromString:(NSString *)repoKeyAsString;
+ (NSString *)stringFromRepoKey:(RepoKey *)repoKey;

@end

@implementation FavoriteReposPersistenceStore

- (void)dealloc
{
    [stateReader release];
    [stateSetter release];
    [super dealloc];
}

#pragma mark PersistenceStore implementation

- (void)load
{
    NSArray * favoriteRepoKeys =
        [PlistUtils getArrayFromPlist:[[self class] plistName]];
    
    for (NSString * repoKeyAsString in favoriteRepoKeys) {
        RepoKey * repoKey = [[self class] repoKeyFromString:repoKeyAsString];
        [stateSetter addFavoriteRepoKey:repoKey];
    }
}

- (void)save
{
    NSMutableArray * serializedRepoKeys = [NSMutableArray array];
    for (RepoKey * repoKey in stateReader.favoriteRepoKeys) {
        NSString * repoKeyAsString = [[self class] stringFromRepoKey:repoKey];
        [serializedRepoKeys addObject:repoKeyAsString];
    }
    
    [PlistUtils saveArray:serializedRepoKeys toPlist:[[self class] plistName]];
}

#pragma mark RepoKey serializers

+ (RepoKey *)repoKeyFromString:(NSString *)repoKeyAsString
{
    NSArray * repoKeyFields =
        [repoKeyAsString
        componentsSeparatedByString:[[self class] repoKeySeparator]];
    NSString * username = [repoKeyFields objectAtIndex:0];
    NSString * repoName = [repoKeyFields objectAtIndex:1];
    
    return [[[RepoKey alloc]
        initWithUsername:username repoName:repoName] autorelease];
}

+ (NSString *)stringFromRepoKey:(RepoKey *)repoKey
{
    return [NSString stringWithFormat:@"%@%@%@", repoKey.username,
        [[self class] repoKeySeparator], repoKey.repoName];
}

#pragma mark Static helper methods

+ (NSString *)plistName
{
    return @"FavoriteReposState";
}

+ (NSString *)repoKeySeparator
{
    return @"|";
}

@end
