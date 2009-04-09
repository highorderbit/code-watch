//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HOTableViewCell : UITableViewCell
{
    UILabel * label;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
    tableViewStyle:(UITableViewStyle)tableViewStyle;

@end
