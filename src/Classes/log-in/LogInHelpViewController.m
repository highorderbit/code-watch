//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInHelpViewController.h"

@implementation LogInHelpViewController

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    self.navigationItem.title = NSLocalizedString(@"loginhelp.view.title", @"");

    NSString * htmlFilePath =
        [[NSBundle mainBundle] pathForResource:@"log-in-help" ofType:@"html"];  
    if (htmlFilePath) {
        NSString * html = [NSString stringWithContentsOfFile:htmlFilePath];

        // Loading the bundle path as the baseURL of the web view will
        // enable us to embed CSS or image files into the HTML later if
        // desired without any additional code.
        NSString * path = [[NSBundle mainBundle] bundlePath];
        NSURL * url = [NSURL URLWithString:path];

        [webView loadHTMLString:html baseURL:url];
    } else
        NSLog(@"Failed to load log in help file.");
}


@end
