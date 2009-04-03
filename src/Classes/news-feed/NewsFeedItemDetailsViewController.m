//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedItemDetailsViewController.h"

@interface NewsFeedItemDetailsViewController (Private)

- (void)updateDisplay;

- (void)setDetails:(NSString *)someDetails;

@end

@implementation NewsFeedItemDetailsViewController

- (void)dealloc
{
    [webView release];
    [details release];
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view,
// typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title =
        NSLocalizedString(@"newsitemdetails.view.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateDisplay];
}

#pragma mark UIWebViewDelegate protocol implementation

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL * url = [request mainDocumentURL];
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }

    return YES;
}

#pragma mark Updating the display

- (void)updateWithDetails:(NSString *)htmlDetails
{
    htmlDetails = [NSString stringWithFormat:
        @"<html><head></head><body>%@</body></html>", htmlDetails];

    NSLog(@"Updating with HTML:\n%@", htmlDetails);

    [self setDetails:htmlDetails];
    [self updateDisplay];
}

- (void)updateDisplay
{
    NSURL * baseUrl = [NSURL URLWithString:@"https://github.com"];
    [webView loadHTMLString:details baseURL:baseUrl];
}

#pragma mark Accessors

- (void)setDetails:(NSString *)someDetails
{
    NSString * tmp = [someDetails copy];
    [details release];
    details = tmp;    
}

@end
