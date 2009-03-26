//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangesetViewControllerDelegate.h"

@interface ChangesetViewController : UITableViewController
{
    NSObject<ChangesetViewControllerDelegate> * delegate;

    NSArray * changeset;
}

@property (nonatomic, retain) NSObject<ChangesetViewControllerDelegate> *
    delegate;

@property (nonatomic, copy, readonly) NSArray * changeset;

- (void)updateWithChangeset:(NSArray *)changeset;

@end
