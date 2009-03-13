//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlistUtils : NSObject {
}

+ (NSDictionary *) readDictionaryFromPlist:(NSString *)path;
+ (void) writeDictionary:(NSDictionary *)dictionary toPlist:(NSString *)path;
+ (NSArray *) readArrayFromPlist:(NSString *)path;
+ (void) writeArray:(NSArray *)array toPlist:(NSString *)path;
+ (NSString *) fullDocumentPathForPlist:(NSString *)plist;
+ (NSString *) fullBundlePathForPlist:(NSString *)plist;
+ (NSDictionary *) getDictionaryFromPlist:(NSString *)plist;
+ (void) saveDictionary:dictionary toPlist:(NSString *)plist;
+ (NSArray *) getArrayFromPlist:(NSString *)plist;
+ (void) saveArray:(NSArray *)array toPlist:(NSString *)plist;
+ (void) removePlistAndCopyDefaultFromBundle:(NSString *)plist;

@end
