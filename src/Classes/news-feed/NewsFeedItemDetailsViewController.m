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
    NSString * formatString =
            @"<html>"
            "<head>"
            "    <style media=\"screen\" type=\"text/css\">"
            "    body {"
            "        width: 90%%;"
            "        padding: 30px;"
            "        font-family: \"Helvetica\";"
            "        font-size: 28pt;"
            "    }"
            "    h3 {"
            "        margin-bottom: -40px;"
            "    }"
            "    p.example {"
            "        color: #2a385b;"
            "    }"
            "    </style>"
            "</head>"
            "<body>"
            "    %@"
            "</body>"
            "</html>";

    htmlDetails = [NSString stringWithFormat:formatString, htmlDetails];

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
