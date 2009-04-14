//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserDetailTableViewCell.h"
#import "UIColor+CodeWatchColors.h"

@implementation UserDetailTableViewCell

- (void)dealloc {
    [keyLabel release];
    [valueLabel release];
    [super dealloc];
}

- (void)setKeyText:(NSString *)text
{
    keyLabel.text = text;
}

- (void)setValueText:(NSString *)text
{
    valueLabel.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.selectionStyle != UITableViewCellSelectionStyleNone) {
        keyLabel.textColor =
            selected ? [UIColor whiteColor] : [UIColor codeWatchLabelColor];
        valueLabel.textColor =
            selected ? [UIColor whiteColor] : [UIColor blackColor];
    }
}

@end
