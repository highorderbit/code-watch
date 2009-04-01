//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchViewControllerDelegate

- (void)processSelection:(NSString *)text fromSection:(NSString *)section;

@end
