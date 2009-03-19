//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "LogInPersistenceStore.h"
#import "PListUtils.h"
#import "SFHFKeychainUtils.h"

@interface LogInPersistenceStore (Private)

+ (NSString*) plistName;

+ (NSString*) loginKey;
+ (NSString*) tokenKey;
+ (NSString*) promptKey;

+ (NSString*) keychainServiceName;

@end

@implementation LogInPersistenceStore

- (void) dealloc
{
    [logInStateReader release];
    [logInStateSetter release];
    [super dealloc];
}

- (void) load
{
    NSDictionary* dict =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];

    NSString* login = [dict objectForKey:[[self class] loginKey]];
    BOOL prompt = [[dict objectForKey:[[self class] promptKey]] boolValue];

/*
 * Encrypting the token in the keychain will prompt the user for a password
 * when run in the simulator, so we'll store tokens in plists to avoid the
 * prompt while testing.
*/
#if TARGET_IPHONE_SIMULATOR

    NSString* token = [dict objectForKey:[[self class] tokenKey]];

#else
    
    NSString* token;
    if (login) {
        NSError* error;
        token =
            [SFHFKeychainUtils getPasswordForUsername:login
            andServiceName:[[self class] keychainServiceName] error:&error];

        if (!error)
            NSLog([error description]);
    } else
        token = nil;
        
#endif

    [logInStateSetter setLogin:login token:token prompt:prompt];
}

- (void) save
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    if (logInStateReader.login)
        [dict setObject:logInStateReader.login forKey:[[self class] loginKey]];

    [dict setObject:[NSNumber numberWithBool:logInStateReader.prompt]
        forKey:[[self class] promptKey]];

/*
 * Encrypting the token in the keychain will prompt the user for a password
 * when run in the simulator, so we'll store tokens in plists to avoid the
 * prompt while testing.
*/
#if TARGET_IPHONE_SIMULATOR

    if (logInStateReader.token)
        [dict setObject:logInStateReader.token forKey:[[self class] tokenKey]];

#else

    if (logInStateReader.token) {
        NSError* error;
        [SFHFKeychainUtils storeUsername:logInStateReader.login
            andPassword:logInStateReader.token
            forServiceName:[[self class] keychainServiceName] updateExisting:YES
            error:&error];
    
        if (!error)
            NSLog([error description]);
    }
    
#endif

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

+ (NSString*) keychainServiceName
{
    return @"code-watch";
}

@end
