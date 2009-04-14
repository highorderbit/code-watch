//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableViewCell : UITableViewCell
{
    IBOutlet UILabel * keyLabel;
    IBOutlet UILabel * valueLabel;
}

- (void)setKeyText:(NSString *)text;
- (void)setValueText:(NSString *)text;

@end
