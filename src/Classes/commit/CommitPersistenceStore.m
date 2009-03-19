//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "CommitPersistenceStore.h"
#import "PListUtils.h"

@interface CommitPersistenceStore (Private)

+ (NSDictionary *)dictionaryFromCommitInfo:(CommitInfo *)commit;
+ (CommitInfo *)commitInfoFromDictionary:(NSDictionary *)dict;

+ (NSString *)detailsKey;

+ (NSString *)plistName;

@end

@implementation CommitPersistenceStore

- (void)load
{
    NSDictionary * commitsAsDicionaries =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];
    
    for (NSString * key in [commitsAsDicionaries allKeys]) {
        NSDictionary * dict = [commitsAsDicionaries objectForKey:key];
        CommitInfo * commitInfo = [[self class] commitInfoFromDictionary:dict];
        [cacheSetter setCommit:commitInfo forKey:key];
    }
}

- (void)save
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSDictionary * commits = cacheReader.allCommits;
    for (NSString * key in [commits allKeys]) {
        CommitInfo * commitInfo = [commits objectForKey:key];
        NSDictionary * commitDict =
            [[self class] dictionaryFromCommitInfo:commitInfo];
        [dict setObject:commitDict forKey:key];
    }

    [PlistUtils saveDictionary:dict toPlist:[[self class] plistName]];
}

#pragma mark Helper methods

+ (NSDictionary *)dictionaryFromCommitInfo:(CommitInfo *)commit
{
    NSMutableDictionary * dict;
    
    if (commit) {
        dict = [NSMutableDictionary dictionary];
        [dict setObject:commit.details forKey:[[self class] detailsKey]];
    } else
        dict = nil;
    
    return dict;
}

+ (CommitInfo *)commitInfoFromDictionary:(NSDictionary *)dict
{
    CommitInfo * commitInfo;
    
    if (dict) {
        NSDictionary * details = [dict objectForKey:[[self class] detailsKey]];
        commitInfo = [[[CommitInfo alloc] initWithDetails:details] autorelease];
    } else
        commitInfo = nil;
    
    return commitInfo;
}

+ (NSString *)detailsKey
{
    return @"details";
}

+ (NSString *)plistName
{
    return @"CommitCache";
}

@end
