//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kChangesetTypeAdded,
    kChangesetTypeRemoved,
    kChangesetTypeModified
} ChangesetType;

@protocol CommitViewControllerDelegate

- (void)userDidSelectChangeset:(NSArray *)changeset ofType:(ChangesetType)type;

@end
