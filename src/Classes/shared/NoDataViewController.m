//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NoDataViewController.h"

@implementation NoDataViewController

- (void)dealloc {
    [label release];
    [activityIndicator release];
    [super dealloc];
}

- (void)setLabelText:(NSString *)text
{
    label.text = text;
}

- (void)startAnimatingActivityIndicator
{
    [activityIndicator startAnimating];
}

- (void)stopAnimatingActivityIndicator
{
    [activityIndicator stopAnimating];
}

@end
