//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "LogInPersistenceStore.h"
#import "PListUtils.h"

@interface LogInPersistenceStore (Private)

+ (NSString*) plistName;

+ (NSString*) loginKey;
+ (NSString*) tokenKey;
+ (NSString*) promptKey;

@end

@implementation LogInPersistenceStore

- (void) dealloc
{
    [logInState release];
    [super dealloc];
}

- (void) load
{
    NSDictionary* dict =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];

    NSString* login = [dict objectForKey:[[self class] loginKey]];
    NSString* token = [dict objectForKey:[[self class] tokenKey]];
    BOOL prompt = [[dict objectForKey:[[self class] promptKey]] boolValue];

    [logInState setLogin:login token:token prompt:prompt];
}

- (void) save
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    if (logInState.login)
        [dict setObject:logInState.login forKey:[[self class] loginKey]];
    if (logInState.token)
        [dict setObject:logInState.token forKey:[[self class] tokenKey]];
    [dict setObject:[NSNumber numberWithBool:logInState.prompt]
        forKey:[[self class] promptKey]];
    
    [PlistUtils saveDictionary:dict toPlist:[[self class] plistName]];
}

+ (NSString*) plistName
{
    return @"LogInState";
}

+ (NSString*) loginKey
{
    return @"login";
}

+ (NSString*) tokenKey
{
    return @"token";
}

+ (NSString*) promptKey
{
    return @"prompt";
}

@end
