//
//  NewTweetViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//



#import "TweetTableViewCell.h"

#import "NewTweetViewController.h"


@interface NewTweetViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (nonatomic, strong) NSArray *sentTweets;

@end


@implementation NewTweetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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


@end
