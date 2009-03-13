//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell (CodeWatchAdditions)

+ (id)createInstance;
+ (id)createInstanceWithReuseIdentifier:(NSString *)reuseIdentifier;
+ (id)createInstanceWithReuseIdentifier:(NSString *)reuseIdentifier
                                  frame:(CGRect)frame;

+ (NSString *)reuseIdentifier;

@end
