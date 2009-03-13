//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInViewController.h"
#import "NameValueTextEntryTableViewCell.h"

static const NSInteger NUM_SECTIONS = 1;

static const NSInteger NUM_CREDENTIALS_ROWS = 2;
enum CredentialsSection
{
    kUsernameRow,
    kTokenRow
};

@implementation LogInViewController

@synthesize tableView;
@synthesize usernameCell, tokenCell;

- (void)dealloc
{
    [tableView release];
    [usernameCell release];
    [tokenCell release];
    [super dealloc];
}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and
    // want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }

    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"login.view.title", @"");

    UIBarButtonItem * logInButtonItem =
        [[UIBarButtonItem alloc]
         initWithTitle:NSLocalizedString(@"login.cancel.title", @"")
                 style:UIBarButtonItemStyleDone
                target:self
                action:@selector(userDidLogIn)];
    UIBarButtonItem * cancelButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                              target:self
                              action:@selector(userDidCancel)];

    [self.navigationItem setRightBarButtonItem:logInButtonItem animated:YES];
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem animated:YES];

    [logInButtonItem release];
    [cancelButtonItem release];
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
*/

/*
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];  // Releases the view if it doesn't have a
                                      // superview

    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return NUM_SECTIONS;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    return NUM_CREDENTIALS_ROWS;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueTextEntryTableViewCell * cell;

    switch (indexPath.row) {
        case kUsernameRow:
            cell = self.usernameCell;
            break;
        case kTokenRow:
            cell = self.tokenCell;
            break;
    }

    return cell;
}

- (void)          tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController =
    //     [[AnotherViewController alloc]
    //      initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)        tableView:(UITableView *)tv
    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)     tableView:(UITableView *)tv
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView
         deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
               withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
        // array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)     tableView:(UITableView *)tv
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)        tableView:(UITableView *)tv
    canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark Accessors

- (NameValueTextEntryTableViewCell *) usernameCell
{
    if (!usernameCell)
        usernameCell = [NameValueTextEntryTableViewCell createInstance];

    return usernameCell;
}

- (NameValueTextEntryTableViewCell *) tokenCell
{
    if (!tokenCell)
        tokenCell = [NameValueTextEntryTableViewCell createInstance];

    return tokenCell;
}

@end
