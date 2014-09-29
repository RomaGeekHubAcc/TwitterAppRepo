//
//  NewTweetViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//

static NSString * const textViewPlaceholder = @"New Message";


#import "TwitterAPIManager.h"
#import "TweetTableViewCell.h"

#import "NewTweetViewController.h"


@interface NewTweetViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    BOOL keyboardIsShown;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (nonatomic, strong) NSArray *sentTweets;

-(IBAction) send:(id)sender;

@end


@implementation NewTweetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.messageTextView.delegate = self;
    [self showPlaceholderForTextView];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getUserTimelineWithScreenName:[TwitterAPIManager sharedInstance].userName];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
}


#pragma mark - UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sentTweets count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    if (!cell) {
        cell = [[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"TweetTableViewCell"];
    }
    NSDictionary *tweet = self.sentTweets[indexPath.row];
    
    [cell setContentWithDicctionary:tweet];
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TWEET_TABLE_VIEW_CELL_HEIGHT;
}


#pragma mark - Delegated methods - UITextViewDelegate

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    [self hidePlaceholderForTextView];
}

-(void) textViewDidEndEditing:(UITextView *)theTextView {
    if (![theTextView hasText]) {
        [self showPlaceholderForTextView];
    }
    
}


#pragma mark - Private methods

-(void) showPlaceholderForTextView {
    self.messageTextView.textColor = [UIColor lightGrayColor];
    self.messageTextView.text = textViewPlaceholder;
}

-(void) hidePlaceholderForTextView {
    self.messageTextView.text = @"";
    self.messageTextView.textColor = [UIColor blackColor];
}

-(void) scrollToBottom {
    if (self.sentTweets.count == 0) {
        return;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.sentTweets.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

-(void) getUserTimelineWithScreenName:(NSString *)userName {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[TwitterAPIManager sharedInstance] getUserTimelineWithScreenName:userName
                                                      completionBlock:^(BOOL success, id responce, NSError *error) {
                                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                          
                                                          if (success) {
                                                              self.sentTweets = responce;
                                                              [self.tableView reloadData];
                                                              [self scrollToBottom];
                                                          }
                                                          else {
                                                              $l("--- getUserTimeline error -> %@", error.debugDescription);
                                                          }
                                                      }];
}


#pragma mark - Action methods

-(IBAction) send:(id)sender {
    NSString *message = self.messageTextView.text;
    if ([message isEqualToString:textViewPlaceholder]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Відхилено"
                                                            message:@"Введіть текст повідомлення"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
//    NSString *testMsg = @"test message from my app using STTwitter";
    
    [[TwitterAPIManager sharedInstance] sendTweet:message
                              withCompletionBlock:^(BOOL success, id responce, NSError *error) {
                                  if (success) {
                                      [self getUserTimelineWithScreenName:[TwitterAPIManager sharedInstance].userName];
                                  } else {
                                      $l("--- sendTweet error -> %@", error.debugDescription);
                                  }
                              }];
}

-(void) keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += keyboardSize.height;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.view setFrame:viewFrame];
                     }
                     completion:^(BOOL finished) {
                         [self scrollToBottom];
                     }];
    
    keyboardIsShown = NO;
}


-(void) keyboardWillShow:(NSNotification *)notification {
    if (keyboardIsShown) {
        return;
    }
#error треба пофіксити висоту TextView...
    NSDictionary* userInfo = [notification userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.view.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= keyboardSize.height - 44.0f;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.view setFrame:viewFrame];
                     }
                     completion:^(BOOL finished) {
                         [self scrollToBottom];
                     }];
    
    keyboardIsShown = YES;
}

@end
