//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

enum UpdatingState
{
    kConnectedAndUpdating,
    kConnectedAndNotUpdating,
    kDisconnected
};

@interface NetworkAwareViewController : UIViewController {
    IBOutlet UIViewController * targetViewController;
    IBOutlet UIView * noDataView;
    IBOutlet UILabel * noDataLabel;
    IBOutlet UIActivityIndicatorView * activityIndicator;
    
    NSInteger updatingState;
    BOOL cachedDataAvailable;
    
    NSString * updatingText;
    NSString * noConnectionText;
    NSString * noConnectionCachedDataText;
}

- (void)setUpdatingState:(NSInteger)state;
- (void)setCachedDataAvailable:(BOOL)available;

- (void)setUpdatingText:(NSString *)text;
- (void)setNoConnectionText:(NSString *)text;
- (void)setNoConnectionCachedDataText:(NSString *)text;

@end
