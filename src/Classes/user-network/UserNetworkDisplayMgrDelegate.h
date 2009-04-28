//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserNetworkDisplayMgrDelegate <NSObject>

- (NSString *)titleForNavigationItem;
- (UIBarButtonItem *)rightBarButtonItem;

@end
