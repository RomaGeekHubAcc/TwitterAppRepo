//
//  HomeViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//


// http://www.ikangai.com/software/writing-a-simple-twitter-iphone-client/





#import "TwitterAPIManager.h"
#import "LoginModalViewController.h"
#import "TweetTableViewCell.h"

#import "HomeViewController.h"


@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tweetItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation HomeViewController


-(void)viewDidLoad {
    [super viewDidLoad];
	
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![TwitterAPIManager sharedInstance].userName) {
        [self presentLoginViewControllerForNavigationController:self.navigationController
                                                       animated:YES];
    }
    
    [[TwitterAPIManager sharedInstance] getHomeTimelineSinceId:nil
                                                         count:100
                                               completionBlock:^(BOOL success, id responce){
                                                   if (success) {
                                                       self.tweetItems = [NSMutableArray arrayWithArray:responce];
                                                       [self.tableView reloadData];
                                                   }
                                               }];
}


#pragma mark - Private methods

-(void) presentLoginViewControllerForNavigationController:(UINavigationController*)navigationController animated:(BOOL)animated {
    LoginModalViewController *loginModalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginModalViewController"];
    loginModalVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [navigationController presentViewController:loginModalVC animated:animated completion:nil];
}


#pragma mark - UITableViewDataSouce methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    if (!cell) {
        cell = [[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"TweetTableViewCell"];
    }
    NSDictionary *tweet = self.tweetItems[indexPath.row];
    
//    cell.senderNameLaber.text = 
//    NSDictionary *user = tweet[@"user"];
    
    cell.tweetTextLabel.text = tweet[@"text"];
    

    
    return cell;
}


@end
