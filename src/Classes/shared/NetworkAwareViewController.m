//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NetworkAwareViewController.h"

@interface NetworkAwareViewController (Private)

- (void)updateView;

@end

@implementation NetworkAwareViewController

- (void)dealloc {
    [targetViewController release];
    [noDataView release];
    [noDataLabel release];
    
    [activityIndicator release];
    [updatingText release];
    [noConnectionText release];
    [noConnectionCachedDataText release];
    
    [super dealloc];
}

- (void) awakeFromNib
{
    noDataView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // TEMPORARY
    [self setCachedDataAvailable:YES];
    [self setUpdatingState:kConnectedAndUpdating];
    [self setUpdatingText:@"Updating..."];
    [self setNoConnectionText:@"No Connection"];
    [self setNoConnectionCachedDataText:@"No Connection - Stale Data"];
    // TEMPORARY
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
    
    if (cachedDataAvailable)
        self.view = targetViewController.view;
    else {
        self.view = noDataView;
        noDataLabel.text =
            updatingState == kDisconnected ? noConnectionText : updatingText;
    }
    
    if (updatingState == kDisconnected)
        [activityIndicator stopAnimating];
    else
        [activityIndicator startAnimating];
}

@end
