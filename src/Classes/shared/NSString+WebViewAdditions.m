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
        "    <style media=\"screen\" type=\"text/css\">"
        "    body {"
        "        width: 90%%;"
        "        padding: 30px;"
        "        font-family: \"Helvetica\";"
        "        font-size: 37pt;"
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

    return [NSString stringWithFormat:formatString, self];
}

@end
