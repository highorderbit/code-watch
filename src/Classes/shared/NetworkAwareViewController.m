//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NetworkAwareViewController.h"

@interface NetworkAwareViewController (Private)

- (NoDataViewController *)noDataViewController;
- (void)updateView;

@end

@implementation NetworkAwareViewController

- (void)dealloc {
    [targetViewController release];
    [noDataViewController release];
    
    [updatingText release];
    [noConnectionText release];
    [noConnectionCachedDataText release];
    
    [super dealloc];
}

- (void) awakeFromNib
{
    [self noDataViewController].view.backgroundColor =
        [UIColor groupTableViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [targetViewController viewWillAppear:animated];
}

#pragma mark State updating methods

- (void)setUpdatingState:(NSInteger)state
{
    updatingState = state;
    [self updateView];
}

- (void)setCachedDataAvailable:(BOOL)available
{
    cachedDataAvailable = available;
    [self updateView];
}

- (void)setUpdatingText:(NSString *)text
{
    text = [text copy];
    [updatingText release];
    updatingText = text;
    
    [self updateView];
}

- (void)setNoConnectionText:(NSString *)text
{
    text = [text copy];
    [noConnectionText release];
    noConnectionText = text;
    
    [self updateView];
}

- (void)setNoConnectionCachedDataText:(NSString *)text
{
    text = [text copy];
    [noConnectionCachedDataText release];
    noConnectionCachedDataText = text;
    
    [self updateView];
}

#pragma mark Private helper methods

- (NoDataViewController *)noDataViewController
{    
    if (!noDataViewController)
        noDataViewController =
            [[NoDataViewController alloc] initWithNibName:@"NoDataView"
            bundle:nil];
    
    return noDataViewController;
}

- (void)updateView
{
    if (cachedDataAvailable) {
        if (updatingState == kConnectedAndUpdating)
            self.navigationItem.prompt = updatingText;
        else if (updatingState == kDisconnected)
            self.navigationItem.prompt = noConnectionCachedDataText;
        else
            self.navigationItem.prompt = nil;
    } else
        self.navigationItem.prompt = nil;
    
    if (cachedDataAvailable) {
        self.view = targetViewController.view;
        [targetViewController viewWillAppear:YES];
    }
    else {
        self.view = [[self noDataViewController] view];
        NSString * labelText =
            updatingState == kDisconnected ? noConnectionText : updatingText;
        [[self noDataViewController] setLabelText:labelText];
    }
    
    if (updatingState == kDisconnected)
        [[self noDataViewController] stopAnimatingActivityIndicator];
    else
        [[self noDataViewController] startAnimatingActivityIndicator];
}

@end
