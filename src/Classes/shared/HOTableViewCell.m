//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "HOTableViewCell.h"

@interface HOTableViewCell (Private)

+ (CGRect)readonlyFrame;
+ (CGRect)editingFrame;

@end

@implementation HOTableViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {        
        label = [[UILabel alloc] initWithFrame:[[self class]readonlyFrame]];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        label.tag = 1;
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.numberOfLines = 1;
        label.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:label];

        self.contentView.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    label.frame =
        editing ? [[self class] editingFrame] : [[self class] readonlyFrame];
}

- (void)dealloc {
    [label release];
    [super dealloc];
}

- (NSString *)text
{
    return label.text;
}

- (void)setText:(NSString *)text
{
    label.text = text;
}

#pragma mark Label frames

+ (CGRect)readonlyFrame
{
    return CGRectMake(10, 0, 280, 44);
}

+ (CGRect)editingFrame
{
    return CGRectMake(10, 0, 240, 44);
}

@end
