//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell (CodeWatchAdditions)

+ (id)createStandardInstance;
+ (id)createStandardInstanceWithReuseIdentifier:(NSString *)identifier;
+ (id)createStandardInstanceWithReuseIdentifier:(NSString *)identifier
                                          frame:(CGRect)frame;

+ (id)createCustomInstance;
+ (id)createCustomInstanceWithNibName:(NSString *)nibName;

+ (NSString *)reuseIdentifier;

@end
