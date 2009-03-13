//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+CodeWatchAdditions.h"

@interface NameValueTextEntryTableViewCell : UITableViewCell
{
    UILabel * nameLabel;
    UITextField * textField;
}

@property (nonatomic, retain) IBOutlet UILabel * nameLabel;
@property (nonatomic, retain) IBOutlet UITextField * textField;

@end
