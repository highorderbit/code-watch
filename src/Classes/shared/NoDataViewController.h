//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataViewController : UIViewController
{
    IBOutlet UILabel * label;
    IBOutlet UIActivityIndicatorView * activityIndicator;
}

- (void)setLabelText:(NSString *)text;
- (void)startAnimatingActivityIndicator;
- (void)stopAnimatingActivityIndicator;

@end
