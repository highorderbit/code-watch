//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "AvatarPersistenceStore.h"
#import "PListUtils.h"

@interface AvatarPersistenceStore (Private)

+ (NSData *)dataFromImage:(UIImage *)image;
+ (UIImage *)imageFromData:(NSData *)data;

+ (NSString *)plistName;

@end

@implementation AvatarPersistenceStore

- (void)dealloc
{
    [cacheReader release];
    [cacheSetter release];
    [super dealloc];
}

#pragma mark PersistenceStore implementation

- (void)load
{
    NSDictionary * dict =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];

    for (NSString * email in dict.allKeys) {
        NSData * data = [dict objectForKey:email];
        UIImage * avatar = [[self class] imageFromData:data];
        [cacheSetter setAvatar:avatar forEmailAddress:email];
    }
}

- (void)save
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    for (NSString * email in cacheReader) {
        UIImage * avatar = [cacheReader avatarForEmailAddress:email];
        NSData * data = [[self class] dataFromImage:avatar];
        if (data)
            [dict setObject:data forKey:email];
    }

    [PlistUtils saveDictionary:dict toPlist:[[self class] plistName]];
}

#pragma mark Serializing UIImages

+ (NSData *)dataFromImage:(UIImage *)image
{
    return UIImageJPEGRepresentation(image, 1.0);
}

+ (UIImage *)imageFromData:(NSData *)data
{
    return [UIImage imageWithData:data];
}

#pragma mark Constants

+ (NSString *)plistName
{
    return @"AvatarCache";
}

@end
