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

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
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
