//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UITableViewCell+CodeWatchAdditions.h"

@implementation UITableViewCell (CodeWatchAdditions)

+ (id)createInstance
{
    NSString * reuseIdentifier = [[self class] reuseIdentifier];
    return [[self class] createInstanceWithReuseIdentifier:reuseIdentifier];
}

+ (id)createInstanceWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [[self class] createInstanceWithReuseIdentifier:reuseIdentifier
                                                     frame:CGRectZero];
}

+ (id)createInstanceWithReuseIdentifier:(NSString *)reuseIdentifier
                                  frame:(CGRect)frame
{
    return [[[[self class] alloc]
             initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier]
            autorelease];
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end
