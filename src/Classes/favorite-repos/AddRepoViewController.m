//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "AddRepoViewController.h"
#import "RepoKey.h"

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
    kRepoNameRow
};

static const NSInteger NUM_HELP_ROWS = 1;
enum HelpSection
{
    kHelpRow
};

@interface AddRepoViewController (Private)

@property (readonly) NameValueTextEntryTableViewCell * usernameCell;
@property (readonly) NameValueTextEntryTableViewCell * repoNameCell;
@property (readonly) UITableViewCell * helpCell;

- (void)userDidSave;
- (void)userDidCancel;
- (BOOL)checkValidityUsername:(NSString *)text repoName:(NSString *)repoName;
- (void)updateUIForCommunicating;

@end

@implementation AddRepoViewController

@synthesize delegate;
@synthesize favoriteReposStateReader;

- (void)dealloc
{
    [delegate release];
    [favoriteReposStateReader release];
    [tableView release];
    [usernameCell release];
    [repoNameCell release];
    [helpCell release];
    [usernameTextField release];
    [repoNameTextField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"addrepo.view.title", @"");
    self.navigationItem.prompt = NSLocalizedString(@"addrepo.view.prompt", @"");
    
    UIBarButtonItem * addRepoButtonItem =
        [[UIBarButtonItem alloc]
        initWithTitle:NSLocalizedString(@"addrepo.addrepo.label", @"")
        style:UIBarButtonItemStyleDone
        target:self
        action:@selector(userDidSave)];
    addRepoButtonItem.enabled = NO;
    
    UIBarButtonItem * cancelButtonItem =
        [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
        target:self
        action:@selector(userDidCancel)];
    
    [self.navigationItem setRightBarButtonItem:addRepoButtonItem animated:YES];
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem animated:YES];

    [addRepoButtonItem release];
    [cancelButtonItem release];
    
    usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    repoNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    usernameTextField.delegate = self;
    repoNameTextField.delegate = self;
    
    self.usernameCell.textField = usernameTextField;
    self.repoNameCell.textField = repoNameTextField;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.helpCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSIndexPath * selection = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selection animated:NO];
    
    self.usernameCell.nameLabel.text =
        NSLocalizedString(@"addrepo.username.label", @"");
    
    self.repoNameCell.nameLabel.text =
        NSLocalizedString(@"addrepo.repoName.label", @"");
    
    [self.usernameCell.textField becomeFirstResponder];
    
    [self promptForRepo];
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
            nrows = NUM_CREDENTIALS_ROWS;
            break;
        case kHelpSection:
            nrows = NUM_HELP_ROWS;
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
            case kRepoNameRow:
                cell = self.repoNameCell;
                break;
        }
    else if (indexPath.section == kHelpSection)
        switch (indexPath.row) {
            case kHelpRow:
                cell = self.helpCell;
                break;
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kHelpSection && indexPath.row == kHelpRow)
        [delegate provideHelp];
}

#pragma mark UITextFieldDelegate functions

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string
{
    NSString * username;
    NSString * repoName;
    
    if (textField == usernameTextField) {
        username =
            [usernameTextField.text stringByReplacingCharactersInRange:range
            withString:string];
        repoName = repoNameTextField.text;
    } else {
        username = usernameTextField.text;
        repoName =
            [repoNameTextField.text stringByReplacingCharactersInRange:range
            withString:string];
    }
    
    self.navigationItem.rightBarButtonItem.enabled =
        [self checkValidityUsername:[username lowercaseString]
        repoName:[repoName lowercaseString]];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL validInput = YES;

    if (textField == usernameTextField) {
        [textField resignFirstResponder];
        [repoNameTextField becomeFirstResponder];
    } else {
        validInput =
            [self checkValidityUsername:[usernameTextField.text lowercaseString]
            repoName:[repoNameTextField.text lowercaseString]];
        
        if (validInput) {
            [textField resignFirstResponder];
            [self userDidSave];
        }
    }

    return validInput;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    return YES;
}

#pragma mark User actions

- (void)userDidSave
{
    self.helpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * username = [usernameTextField.text lowercaseString];
    NSString * repoName = [repoNameTextField.text lowercaseString];
    
    [self updateUIForCommunicating];
    [delegate userProvidedUsername:username repoName:repoName];
}

- (void)userDidCancel
{
    [delegate userDidCancel];
    self.usernameCell.textField.text = @"";
    self.repoNameCell.textField.text = @"";
}

#pragma mark UI configuration

- (void)promptForRepo
{
    NSString * username = usernameTextField.text;
    NSString * repoName = repoNameTextField.text;
    self.navigationItem.rightBarButtonItem.enabled =
        [self checkValidityUsername:username repoName:repoName];
    self.navigationItem.prompt = NSLocalizedString(@"addrepo.view.prompt", @"");
    self.usernameCell.textField.enabled = YES;
    self.repoNameCell.textField.enabled = YES;
}

- (void)updateUIForCommunicating
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.prompt =
        NSLocalizedString(@"addrepo.communicating.prompt", @"");
    self.usernameCell.textField.enabled = NO;
    self.repoNameCell.textField.enabled = NO;
}

- (void)repoAccepted
{
    self.usernameCell.textField.text = @"";
    self.repoNameCell.textField.text = @"";
}

#pragma mark Accessors

- (NameValueTextEntryTableViewCell *)usernameCell
{
    if (!usernameCell)
        usernameCell =
        [[NameValueTextEntryTableViewCell createCustomInstance] retain];
    
    return usernameCell;
}

- (NameValueTextEntryTableViewCell *)repoNameCell
{
    if (!repoNameCell)
        repoNameCell =
        [[NameValueTextEntryTableViewCell createCustomInstance] retain];
    
    return repoNameCell;
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

#pragma mark Helper methods

- (BOOL)checkValidityUsername:(NSString *)username repoName:(NSString *)repoName
{
    NSArray * favoriteRepos = favoriteReposStateReader.favoriteRepoKeys;
    RepoKey * repoKey =
        [[RepoKey alloc] initWithUsername:username repoName:repoName];

    return username.length > 0 && repoName.length > 0 &&
        ![favoriteRepos containsObject:repoKey];
    return YES;
}

@end
