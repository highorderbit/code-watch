//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NameValueTextEntryTableViewCell.h"

@implementation NameValueTextEntryTableViewCell

@synthesize nameLabel, textField;

- (void)dealloc
{
    [nameLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
