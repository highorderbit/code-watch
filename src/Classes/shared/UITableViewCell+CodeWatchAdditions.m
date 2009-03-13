//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UITableViewCell+CodeWatchAdditions.h"
#import "NSObject+RuntimeAdditions.h"

@implementation UITableViewCell (CodeWatchAdditions)

+ (id)createStandardInstance
{
    NSString * identifier = [[self class] reuseIdentifier];
    return [[self class] createStandardInstanceWithReuseIdentifier:identifier];
}

+ (id)createStandardInstanceWithReuseIdentifier:(NSString *)identifier
{
    return [[self class] createStandardInstanceWithReuseIdentifier:identifier
                                            frame:CGRectZero];
}

+ (id)createStandardInstanceWithReuseIdentifier:(NSString *)identifier
                                          frame:(CGRect)frame
{
    return [[[[self class] alloc]
             initWithFrame:CGRectZero reuseIdentifier:identifier]
            autorelease];
}

+ (id)createCustomInstance
{
    NSString * nibName = [self className];
    return [[self class] createCustomInstanceWithNibName:nibName];
}

+ (id)createCustomInstanceWithNibName:(NSString *)nibName
{
    NSArray * nib =
        [[NSBundle mainBundle]
          loadNibNamed:nibName
                 owner:self
               options:nil];

    return [nib objectAtIndex:0];
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end