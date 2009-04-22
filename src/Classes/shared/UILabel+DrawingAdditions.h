//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum UILabelSizeToFitAlignment {
    UILabelSizeToFitAlignmentLeft,
    UILabelSizeToFitAlignmentRight
} UILabelSizeToFitAlignment;

@interface UILabel (DrawingAdditions)

- (CGFloat)heightForString:(NSString *)s;

- (void)sizeToFit:(UILabelSizeToFitAlignment)alignment;

@end
