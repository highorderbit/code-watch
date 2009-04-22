//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UILabel+DrawingAdditions.h"

@implementation UILabel (DrawingAdditions)

- (CGFloat)heightForString:(NSString *)s
{
    CGRect frame = self.frame;

    CGSize maxSize = CGSizeMake(frame.size.width, 99999.0);
    UILineBreakMode lbMode = UILineBreakModeWordWrap;

    UIFont * font = self.font;

    CGSize size =
        [s sizeWithFont:font constrainedToSize:maxSize lineBreakMode:lbMode];

    return size.height;
}

- (void)sizeToFit:(UILabelSizeToFitAlignment)alignment
{
    if (alignment == UILabelSizeToFitAlignmentLeft)
        [self sizeToFit];
    else {
        CGFloat xright = self.frame.origin.x + self.frame.size.width;

        [self sizeToFit];

        CGRect frame = self.frame;
        frame.origin.x = xright - frame.size.width;

        self.frame = frame;
    }
}

@end
