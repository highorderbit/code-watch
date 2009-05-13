//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NameValueTextEntryTableViewCell.h"

@implementation NameValueTextEntryTableViewCell

@synthesize nameLabel, textField;

- (void)dealloc
{
    [nameLabel release];
    [textField release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // needed for iPhone OS 3.0 beta 5
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Accessors

- (void)setTextField:(UITextField *)aTextField
{
    [textField removeFromSuperview];
    UITextField * tmp = [aTextField retain];
    [textField release];
    textField = tmp;

    // set the frame of the text field correctly
    CGRect frame = CGRectMake(105.0, 7.0, 200.0, 31.0);
    textField.frame = frame;

    [self addSubview:textField];
}

@end
