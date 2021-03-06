//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "DiffViewController.h"

@interface DiffViewController (Private)
- (void)display;
- (void)setDiff:(NSDictionary *)aDiff;
@end

@implementation DiffViewController

@synthesize diff;

- (void)dealloc
{
    [webView release];

    [diff release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#if defined(__IPHONE_3_0)
    webView.dataDetectorTypes =
        UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self display];
}

#pragma mark Updating the displayed data

- (void)updateWithDiff:(NSDictionary *)aDiff
{
    [self setDiff:aDiff];
    [self display];
}

- (void)display
{
    NSString * filename = [[diff objectForKey:@"filename"] lastPathComponent];
    self.navigationItem.title = filename;

    NSString * html =
        [NSString stringWithFormat:
        @"<html><head><style media=\"screen\" type=\"text/css\">"
        "body {font-size:18pt}</style></head><body><pre>%@</pre></body></html>",
        [diff objectForKey:@"diff"]];

    [webView loadHTMLString:html baseURL:nil];
}

#pragma mark Accessors

- (void)setDiff:(NSDictionary *)aDiff
{
    NSDictionary * tmp = [aDiff copy];
    [diff release];
    diff = tmp;
}

@end
