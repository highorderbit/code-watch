//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "DiffViewController.h"

@implementation DiffViewController

- (void)dealloc
{
    [webView release];

    [super dealloc];
}

#pragma mark Updating the displayed data

- (void)updateWithDiff:(NSDictionary *)diff
{
    NSString * filename = [[diff objectForKey:@"filename"] lastPathComponent];
    self.navigationItem.title = filename;

    NSString * html = [diff objectForKey:@"diff"];

    [webView loadHTMLString:html baseURL:nil];
}

@end