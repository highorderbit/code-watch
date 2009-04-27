//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NetworkAwareViewController.h"
#import "UIColor+CodeWatchColors.h"

@interface NetworkAwareViewController (Private)

- (NoDataViewController *)noDataViewController;
- (void)updateView;
- (UIView *)updatingView;

+ (CGRect)shownUpdatingViewFrame;
+ (CGRect)hiddenUpdatingViewFrame;
+ (CGFloat)leftUpdatingViewMargin;

@end

static const CGFloat Y = 338;
static const CGFloat SCREEN_WIDTH = 320;
static const CGFloat VIEW_LENGTH = 320;
static const CGFloat VIEW_HEIGHT = 30;
static const CGFloat ACTIVITY_INDICATOR_LENGTH = 20;

@implementation NetworkAwareViewController

@synthesize delegate, cachedDataAvailable;

- (void)dealloc {
    [delegate release];
    
    [targetViewController release];
    [noDataViewController release];
    
    [updatingText release];
    [loadingText release];
    [noConnectionText release];
    
    [updatingView release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [self initWithTargetViewController:targetViewController];
}

- (id)initWithTargetViewController:(UIViewController *)aTargetViewController
{
    if (self = [super init]) {
        [self noDataViewController].view.backgroundColor =
            [UIColor codeWatchBackgroundColor];
        
        [self setUpdatingText:NSLocalizedString(@"nodata.updating.text", @"")];
        [self setLoadingText:NSLocalizedString(@"nodata.loading.text", @"")];
        NSString * tempNoConnectionText =
            NSLocalizedString(@"nodata.noconnection.text", @"");
        [self setNoConnectionText:tempNoConnectionText];
                
        [aTargetViewController retain];
        [targetViewController release];
        targetViewController = aTargetViewController;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [targetViewController viewWillAppear:animated];
    [delegate viewWillAppear];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    visible = YES;
    [targetViewController.view.superview addSubview:[self updatingView]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    visible = NO;
    [[self updatingView] removeFromSuperview];
}

#pragma mark State updating methods

- (void)setUpdatingState:(NSInteger)state
{
    updatingState = state;
    [self updateView];
}

- (void)setCachedDataAvailable:(BOOL)available
{
    BOOL transitioningToAvailable =
        !cachedDataAvailable && available && ![[self updatingView] superview];
    cachedDataAvailable = available;
    [self updateView];
    if (transitioningToAvailable && visible)
        [targetViewController.view.superview addSubview:[self updatingView]];
}

- (void)setUpdatingText:(NSString *)text
{
    text = [text copy];
    [updatingText release];
    updatingText = text;
    
    [self updateView];
}

- (void)setLoadingText:(NSString *)text
{
    text = [text copy];
    [loadingText release];
    loadingText = text;
    
    [self updateView];
}

- (void)setNoConnectionText:(NSString *)text
{
    text = [text copy];
    [noConnectionText release];
    noConnectionText = text;
    
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
    // set view
    if (cachedDataAvailable) {
        self.view = targetViewController.view;
        [targetViewController viewWillAppear:YES];
    } else {
        self.view = [[self noDataViewController] view];
        
        // this seems to get overwritten on the device occasionally, so force
        // it here
        [self noDataViewController].view.backgroundColor =
            [UIColor codeWatchBackgroundColor];

        // set no data text
        NSString * labelText =
            updatingState == kDisconnected ? noConnectionText : loadingText;
        [[self noDataViewController] setLabelText:labelText];
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone
        forView:self.updatingView cache:NO];

    // position updating view
    if (cachedDataAvailable && updatingState == kConnectedAndUpdating)
        self.updatingView.frame = [[self class] shownUpdatingViewFrame];
    else
        self.updatingView.frame = [[self class] hiddenUpdatingViewFrame];

    [UIView commitAnimations];
    
    // set no data activity indicator animation state
    if (updatingState == kDisconnected)
        [[self noDataViewController] stopAnimatingActivityIndicator];
    else
        [[self noDataViewController] startAnimatingActivityIndicator];
}

- (UIView *)updatingView
{
    if (!updatingView) {
        updatingView =
            [[UIView alloc]
            initWithFrame:[[self class] hiddenUpdatingViewFrame]];
        updatingView.backgroundColor =
            [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        CGRect labelFrame =
            CGRectMake(VIEW_HEIGHT, 0, VIEW_LENGTH - VIEW_HEIGHT, VIEW_HEIGHT);
        UILabel * updatingLabel = [[UILabel alloc] initWithFrame:labelFrame];
        updatingLabel.text = updatingText;
        updatingLabel.textColor = [UIColor whiteColor];
        updatingLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        updatingLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        updatingLabel.font = [UIFont boldSystemFontOfSize:18];
        [updatingView addSubview:updatingLabel];
        
        const CGFloat ACTIVITY_INDICATOR_MARGIN =
            (VIEW_HEIGHT - ACTIVITY_INDICATOR_LENGTH) / 2;
        CGRect activityIndicatorFrame =
            CGRectMake(ACTIVITY_INDICATOR_MARGIN, ACTIVITY_INDICATOR_MARGIN, 20,
            20);
        UIActivityIndicatorView * activityIndicator =
            [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.frame = activityIndicatorFrame;
        [activityIndicator startAnimating];
        [updatingView addSubview:activityIndicator];
    }

    return updatingView;
}

#pragma mark Static helper methods

+ (CGRect)shownUpdatingViewFrame
{
    return CGRectMake([NetworkAwareViewController leftUpdatingViewMargin], Y,
        VIEW_LENGTH, VIEW_HEIGHT);
}

+ (CGRect)hiddenUpdatingViewFrame
{
    return CGRectMake([NetworkAwareViewController leftUpdatingViewMargin],
        Y + VIEW_HEIGHT, VIEW_LENGTH, VIEW_HEIGHT);
}

+ (CGFloat)leftUpdatingViewMargin
{
    return (SCREEN_WIDTH - VIEW_LENGTH) / 2;
}

@end
