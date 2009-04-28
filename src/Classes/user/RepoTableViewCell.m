//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "RepoTableViewCell.h"

@implementation RepoTableViewCell

- (void)dealloc {
    [label release];
    [iconView release];
    [super dealloc];
}

- (void)setText:(NSString *)text
{
    label.text = text;
}

- (NSString *)text
{
    return label.text;
}

- (void)setIcon:(UIImage *)image
{
    iconView.image = image;
}

- (UIImage *)icon
{
    return iconView.image;
}

@end
