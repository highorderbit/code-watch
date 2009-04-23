//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoInfo.h"

@implementation RepoInfo

@synthesize details, commitKeys;

- (void)dealloc
{
    [details release];
    [commitKeys release];
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithDetails:(NSDictionary *)someDetails
{
    return [self initWithDetails:someDetails commitKeys:nil];
}

- (id)initWithDetails:(NSDictionary *)someDetails
           commitKeys:(NSArray *)someCommitKeys
{
    if (self = [super init]) {
        details = [someDetails copy];
        commitKeys = [someCommitKeys copy];
    }

    return self;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];  // object is immutable
}

@end
