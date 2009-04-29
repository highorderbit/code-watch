//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInViewController.h"
#import "NameValueTextEntryTableViewCell.h"
#import "UIColor+CodeWatchColors.h"

static const NSInteger NUM_SECTIONS = 2;
enum Sections
{
    kCredentialsSection,
    kHelpSection
};

static const NSInteger NUM_CREDENTIALS_ROWS = 2;
enum CredentialsSection
{
    kUsernameRow,
    kTokenRow
};

static const NSInteger NUM_HELP_ROWS = 1;
enum HelpSection
{
    kUpgradeRow,
    kHelpRow
};

@interface LogInViewController (Private)

- (void)userDidSave;
- (void)userDidCancel;
- (BOOL)checkUsernameValid:(NSString *)text;
- (void)updateUIForCommunicating;

@end

@implementation LogInViewController

@synthesize delegate;
@synthesize tableView;
@synthesize usernameCell, tokenCell, upgradeCell, helpCell;
@synthesize usernameTextField, tokenTextField;

- (void)dealloc
{
    [delegate release];
    [tableView release];
    [usernameCell release];
    [tokenCell release];
    [helpCell release];
    [upgradeCell release];
    [usernameTextField release];
    [tokenTextField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"login.view.title", @"");
    self.navigationItem.prompt = NSLocalizedString(@"login.view.prompt", @"");

    UIBarButtonItem * logInButtonItem =
        [[UIBarButtonItem alloc]
         initWithTitle:NSLocalizedString(@"login.login.label", @"")
                 style:UIBarButtonItemStyleDone
                target:self
                action:@selector(userDidSave)];
    logInButtonItem.enabled = NO;

    UIBarButtonItem * cancelButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                              target:self
                              action:@selector(userDidCancel)];

    [self.navigationItem setRightBarButtonItem:logInButtonItem animated:YES];
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem animated:YES];

    [logInButtonItem release];
    [cancelButtonItem release];

    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tokenTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.usernameTextField.delegate = self;
    self.tokenTextField.delegate = self;

#if defined(HOB_CODE_WATCH_LITE)

    self.usernameTextField.returnKeyType = UIReturnKeyDone;

#endif

    self.usernameCell.textField = self.usernameTextField;
    self.tokenCell.textField = self.tokenTextField;
    
    self.tableView.backgroundColor = [UIColor codeWatchBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.helpCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.upgradeCell.selectionStyle = UITableViewCellSelectionStyleBlue;

    NSIndexPath * selection = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selection animated:NO];

    self.usernameCell.nameLabel.text =
        NSLocalizedString(@"login.username.label", @"");
    self.tokenCell.nameLabel.text =
        NSLocalizedString(@"login.token.label", @"");

    [self promptForLogIn];
}

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
    NSInteger nrows = 0;

    switch (section) {
        case kCredentialsSection:
#if defined(HOB_CODE_WATCH_LITE)

            nrows = NUM_CREDENTIALS_ROWS - 1;

#else
            nrows = NUM_CREDENTIALS_ROWS;

#endif

            break;
        case kHelpSection:

#if defined(HOB_CODE_WATCH_LITE)

            nrows = NUM_HELP_ROWS + 1;

#else

            nrows = NUM_HELP_ROWS;

#endif

            break;
    }

    return nrows;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;

    if (indexPath.section == kCredentialsSection)
        switch (indexPath.row) {
            case kUsernameRow:
                cell = self.usernameCell;
                break;
            case kTokenRow:
                cell = self.tokenCell;
                break;
        }
    else if (indexPath.section == kHelpSection) {

#if defined (HOB_CODE_WATCH_LITE)

        NSUInteger row = indexPath.row;

#else

        NSUInteger row = indexPath.row + 1;

#endif

        switch (row) {
            case kUpgradeRow:
                cell = self.upgradeCell;
                break;
            case kHelpRow:
                cell = self.helpCell;
                break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kHelpSection && indexPath.row == kHelpRow)
        [delegate provideHelp];
    else if (indexPath.section == kHelpSection && indexPath.row == kUpgradeRow)
        [delegate provideUpgradeHelp];
}

#pragma mark UITextFieldDelegate functions

- (BOOL)                textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string
{
    if (textField == usernameTextField) {
        NSString * text = [textField.text
            stringByReplacingCharactersInRange:range withString:string];
        self.navigationItem.rightBarButtonItem.enabled = text.length > 0;
    } else {

#if defined (HOB_EASY_LOGIN)

        NSString * token = [textField.text
            stringByReplacingCharactersInRange:range withString:string];

        // TODO: For testing only; remove when appropriate
        NSString * user = [usernameTextField.text lowercaseString];
        if ([user isEqual:@"jad"] && [token isEqual:@"898"]) {
            textField.text = @"898dd101a9c690b6d48f91187d8c4652";
            return NO;
        } else if ([user isEqual:@"highorderbit"] && [token isEqual:@"245"]) {
            textField.text = @"24579632190e7e1cc79f1c6a46090a7d";
            return NO;
        }

#endif

    }

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == usernameTextField)
        self.navigationItem.rightBarButtonItem.enabled = NO;

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usernameTextField) {

#if defined(HOB_CODE_WATCH_LITE)

        if (usernameTextField.text.length > 0) {
            [textField resignFirstResponder];
            [self userDidSave];
            return YES;
        }

#else

        [textField resignFirstResponder];
        [self.tokenTextField becomeFirstResponder];
        return YES;

#endif

    } else if (textField == tokenTextField && usernameTextField.text.length) {
        [textField resignFirstResponder];
        [self userDidSave];
        return YES;
    }

    return NO;
}

#pragma mark User actions

- (void)userDidSave
{
    self.helpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.upgradeCell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString * username = [usernameTextField.text lowercaseString];
    NSString * token =
        tokenTextField.text.length > 0 ? tokenTextField.text : nil;

    [self updateUIForCommunicating];
    [delegate userProvidedUsername:username token:token];
}

- (void)userDidCancel
{
    [delegate userDidCancel];
    self.usernameCell.textField.text = @"";
    self.tokenCell.textField.text = @"";
}

- (void)promptForLogIn
{
    NSString * username = usernameTextField.text;
    self.navigationItem.rightBarButtonItem.enabled =
        [self checkUsernameValid:username];
    self.navigationItem.prompt = NSLocalizedString(@"login.view.prompt", @"");
    self.usernameCell.textField.enabled = YES;
    self.tokenCell.textField.enabled = YES;
    [self.usernameCell.textField becomeFirstResponder];
    
}

- (void)updateUIForCommunicating
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.prompt =
        NSLocalizedString(@"login.communicating.prompt", @"");
    self.usernameCell.textField.enabled = NO;
    self.tokenCell.textField.enabled = NO;
}

- (void)logInAccepted
{
    self.usernameCell.textField.text = @"";
    self.tokenCell.textField.text = @"";
}

#pragma mark Accessors

- (NameValueTextEntryTableViewCell *)usernameCell
{
    if (!usernameCell)
        usernameCell =
            [[NameValueTextEntryTableViewCell createCustomInstance] retain];

    return usernameCell;
}

- (NameValueTextEntryTableViewCell *)tokenCell
{
    if (!tokenCell)
        tokenCell =
            [[NameValueTextEntryTableViewCell createCustomInstance] retain];

    return tokenCell;
}

- (UITableViewCell *)helpCell
{
    if (helpCell == nil) {
        static NSString * reuseIdentifier = @"HelpTableViewCell";

        helpCell =
            [[UITableViewCell
                createStandardInstanceWithReuseIdentifier:reuseIdentifier]
             retain];
        helpCell.text = NSLocalizedString(@"login.help.label", @"");
        helpCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return helpCell;
}

- (UITableViewCell *)upgradeCell
{
    if (upgradeCell == nil) {
        static NSString * reuseIdentifier = @"UpgradeTableViewCell";

        upgradeCell =
            [[UITableViewCell
                createStandardInstanceWithReuseIdentifier:reuseIdentifier]
             retain];
        upgradeCell.text = NSLocalizedString(@"login.upgrade.label", @"");
        upgradeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return upgradeCell;
}

#pragma mark Helper methods

- (BOOL)checkUsernameValid:(NSString *)text
{
    return text.length > 0;
}

@end
