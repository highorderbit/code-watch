//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoTableViewCell : UITableViewCell
{
    IBOutlet UILabel * label;
    IBOutlet UIImageView * iconView;
}

@property (nonatomic, retain) UIImage * icon;

@end
