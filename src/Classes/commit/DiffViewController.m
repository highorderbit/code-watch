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
            @"<html><head></head><body><pre>%@</pre></body></html>",
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
