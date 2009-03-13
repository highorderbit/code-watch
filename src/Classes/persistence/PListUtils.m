//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "PlistUtils.h"

@interface PlistUtils (Private)

+ (id) readObjectFromPlist:(NSString *)path;
+ (void) writeObject:(id)obj toPlist:(NSString *)path;

@end

@implementation PlistUtils

+ (NSDictionary *) readDictionaryFromPlist:(NSString *)path
{
    return (NSDictionary *) [self readObjectFromPlist:path];
}

+ (void) writeDictionary:(NSDictionary *)dictionary toPlist:(NSString *)path
{
    [self writeObject:dictionary toPlist:path];
}

+ (NSArray *) readArrayFromPlist:(NSString *)path
{
    return (NSArray *) [self readObjectFromPlist:path];
}

+ (void) writeArray:(NSArray *)array toPlist:(NSString *)path
{
    [self writeObject:array toPlist:path];
}

+ (id) readObjectFromPlist:(NSString *)path
{
    NSString * errorDesc = nil;
    NSPropertyListFormat format;
    NSData * plistXml = [[NSFileManager defaultManager] contentsAtPath:path];

    id temp =
        [NSPropertyListSerialization
        propertyListFromData:plistXml
        mutabilityOption:NSPropertyListMutableContainersAndLeaves
        format:&format
        errorDescription:&errorDesc];

    if (!temp) {
        NSLog(errorDesc);

        // must be released by caller per Apple documentation
        [errorDesc release];  
    }

    return temp;
}

+ (void) writeObject:(id)obj toPlist:(NSString *)path
{
    NSString * errorDesc;
    NSData * plistData =
        [NSPropertyListSerialization
        dataFromPropertyList:obj
        format:NSPropertyListXMLFormat_v1_0
        errorDescription:&errorDesc];

    if (plistData)
        [plistData writeToFile:path atomically:YES];
    else {
        NSLog(errorDesc);

        // must be released by caller per Apple documentation
        [errorDesc release];  
    }
}

+ (NSString *) fullDocumentPathForPlist:(NSString *)plist
{
    NSString * file = [plist stringByAppendingString:@".plist"];
    NSArray * paths =
        NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];

    NSLog(@"Full path to PList files: '%@'.", documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:file];
}

+ (NSString *) fullBundlePathForPlist:(NSString *)plist
{    
    return [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
}

+ (NSDictionary *) getDictionaryFromPlist:(NSString *)plist
{
    NSString * fullPath = [PlistUtils fullDocumentPathForPlist:plist];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:fullPath];
    if (!fileExists) {        
        NSError * error = nil;
        NSString * bundlePath = [PlistUtils fullBundlePathForPlist:plist];
        BOOL fileCopied = [fileManager copyItemAtPath:bundlePath
                                               toPath:fullPath
                                                error:&error];
        if (!fileCopied)
            NSLog([error description]);
    }
    
    return [PlistUtils readDictionaryFromPlist:fullPath];
}

+ (void) saveDictionary:dictionary toPlist:(NSString *)plist
{
    NSString * fullPath = [PlistUtils fullDocumentPathForPlist:plist];
    [PlistUtils writeDictionary:dictionary toPlist:fullPath];
}

+ (NSArray *) getArrayFromPlist:(NSString *)plist
{
    NSString * fullPath = [PlistUtils fullDocumentPathForPlist:plist];

    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:fullPath];
    if (!fileExists) {
        NSError * error = nil;
        NSString * bundlePath = [PlistUtils fullBundlePathForPlist:plist];
        BOOL fileCopied = [fileManager copyItemAtPath:bundlePath
                                               toPath:fullPath
                                                error:&error];
        if (!fileCopied)
            NSLog([error description]);
    }

    return [PlistUtils readArrayFromPlist:fullPath];
}

+ (void) saveArray:(NSArray *)array toPlist:(NSString *)plist
{
    NSString * fullPath = [PlistUtils fullDocumentPathForPlist:plist];
    [PlistUtils writeArray:array toPlist:fullPath];
}

+ (void) removePlistAndCopyDefaultFromBundle:(NSString *)plist
{
    NSString * fullPath = [PlistUtils fullDocumentPathForPlist:plist];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:fullPath];
    if (fileExists) {
        NSError * error = nil;
        BOOL fileRemoved = [fileManager removeItemAtPath:fullPath error:&error];
        
        if (!fileRemoved)
            NSLog([error description]);
        else {
            NSString * bundlePath = [PlistUtils fullBundlePathForPlist:plist];
            BOOL fileCopied =
            [fileManager copyItemAtPath:bundlePath toPath:fullPath
                                  error:&error];
            if (!fileCopied)
                NSLog([error description]);
        }
    }    
}

@end
