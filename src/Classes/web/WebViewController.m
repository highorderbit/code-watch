//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "WebViewController.h"
#import "NSString+WebViewAdditions.h"

@implementation WebViewController

- (id)initWithHtmlFilename:(NSString *)htmlFilename
{
    if (self = [super init]) {
        UIWebView * webView = [[UIWebView alloc] init];
        webView.scalesPageToFit = YES;
        self.view = webView;
            
        NSString * htmlFilePath =
            [[NSBundle mainBundle] pathForResource:htmlFilename ofType:@"html"];
        if (htmlFilePath) {
            NSString * html =
                [[NSString stringWithContentsOfFile:htmlFilePath]
                wrapHTMLForWebViewDisplay];
            
            // Loading the bundle path as the baseURL of the web view will
            // enable us to embed CSS or image files into the HTML later if
            // desired without any additional code.
            NSString * path = [[NSBundle mainBundle] bundlePath];
            NSURL * url = [NSURL fileURLWithPath:path];

            webView.delegate = self;
    
            [webView loadHTMLString:html baseURL:url];
        } else
            NSLog(@"Failed to load html file.");
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    // Resize the web view to account for the prompt removal
    // ...there must be a better way
    self.view.frame = CGRectMake(0, 0, 320, 416);
}

#pragma mark UIWebViewDelegate implementation

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL * url = [request URL];
        [[UIApplication sharedApplication] openURL:url];

        return NO;
    }

    return YES;
}

@end
