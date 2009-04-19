//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NSString+WebViewAdditions.h"

@implementation NSString (WebViewAdditions)

- (NSString *)wrapHTMLForWebViewDisplay
{
    NSString * formatString =
        @"<html>"
        "<head>"
        "    <style media=\"screen\" type=\"text/css\" rel=\"stylesheet\">"
        "       @import url(style.css);"
        "    </style>"
        "</head>"
        "<body>"
        "    %@"
        "</body>"
        "</html>";

    return [NSString stringWithFormat:formatString, self];
}

@end
