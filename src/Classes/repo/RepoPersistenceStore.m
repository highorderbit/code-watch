//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "RepoPersistenceStore.h"
#import "PListUtils.h"
#import "RepoInfo.h"

@interface RepoPersistenceStore (Private)

+ (NSDictionary *)dictionaryFromRepoInfo:(RepoInfo *)repoInfo;
+ (RepoInfo *)repoInfoFromDictionary:(NSDictionary *)dict;

+ (NSString *)detailsKey;
+ (NSString *)commitKeysKey;

+ (NSString *)plistName;

@end

@implementation RepoPersistenceStore

- (void)dealloc
{
    [cacheReader release];
    [cacheSetter release];
    [super dealloc];
}

#pragma mark PersistenceStore implementation

- (void)load
{
    NSDictionary * reposAsDicionaries =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];
    
    for (NSString * repoName in [reposAsDicionaries allKeys]) {
        NSDictionary * dict = [reposAsDicionaries objectForKey:repoName];
        RepoInfo * repoInfo = [[self class] repoInfoFromDictionary:dict];
        [cacheSetter setPrimaryUserRepo:repoInfo forRepoName:repoName];
    }
}

- (void)save
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSDictionary * repos = cacheReader.allPrimaryUserRepos;
    for (NSString * repoName in [repos allKeys]) {
        RepoInfo * repoInfo = [repos objectForKey:repoName];
        NSDictionary * repoDict =
            [[self class] dictionaryFromRepoInfo:repoInfo];
        [dict setObject:repoDict forKey:repoName];
    }

    [PlistUtils saveDictionary:dict toPlist:[[self class] plistName]];
}

#pragma mark Static helpers

+ (NSDictionary *)dictionaryFromRepoInfo:(RepoInfo *)repoInfo
{
    NSMutableDictionary * dict;
    
    if (repoInfo) {
        dict = [NSMutableDictionary dictionary];
        [dict setObject:repoInfo.details forKey:[[self class] detailsKey]];
        if (repoInfo.commitKeys) // commitKeys can be nil
            [dict setObject:repoInfo.commitKeys
                forKey:[[self class] commitKeysKey]];
    } else
        dict = nil;
    
    return dict;
}

+ (RepoInfo *)repoInfoFromDictionary:(NSDictionary *)dict
{
    RepoInfo * repoInfo;
    
    if (dict) {
        NSDictionary * details = [dict objectForKey:[[self class] detailsKey]];
        NSArray * commitKeys = [dict objectForKey:[[self class] commitKeysKey]];
        repoInfo =
            [[[RepoInfo alloc]
            initWithDetails:details commitKeys:commitKeys] autorelease];
    } else
        repoInfo = nil;
    
    return repoInfo;
}

+ (NSString *)detailsKey
{
    return @"details";
}

+ (NSString *)commitKeysKey
{
    return @"commitKeys";
}

+ (NSString *)plistName
{
    return @"RepoCache";
}

@end
