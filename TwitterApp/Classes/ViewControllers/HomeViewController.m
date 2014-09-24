//
//  HomeViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//


#import "TwitterAPIManager.h"
#import "LoginModalViewController.h"
#import "TweetTableViewCell.h"

#import "HomeViewController.h"


@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tweetItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)logOut:(id)sender;

@end


@implementation HomeViewController


-(void)viewDidLoad {
    [super viewDidLoad];
	
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:TWITTER_USER_NAME];
    
    if (!userName && ![TwitterAPIManager sharedInstance].userName) {
        [self presentLoginViewControllerForNavigationController:self.navigationController
                                                       animated:YES];
    }
    if (![TwitterAPIManager sharedInstance].isAuthorized) {
        [self oauth];
    }
    
}


#pragma mark - Private methods

-(void) oauth {
    [[TwitterAPIManager sharedInstance] onlyAutentificationWithCompletion:^(BOOL success, id responce, NSError *error) {
        if (success) {
            [self getHomeTimeline];
        }
    }];
}

-(void) getHomeTimeline {
    [[TwitterAPIManager sharedInstance] getHomeTimelineSinceId:nil
                                                         count:100
                                               completionBlock:^(BOOL success, id responce, NSError *error){
                                                   if (success) {
                                                       self.tweetItems = [NSMutableArray arrayWithArray:responce];
                                                       [self.tableView reloadData];
                                                   }
                                                   else {
                                                       $l("Error - %@", error);
                                                   }
                                               }];
}

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
    
    [cell setContentWithDicctionary:tweet];
    
    return cell;
}


#pragma mark - Action methods

- (IBAction)logOut:(id)sender {
    self.tweetItems = nil;
    [self.tableView reloadData];
    [[TwitterAPIManager sharedInstance] deleteUserData];
    [self presentLoginViewControllerForNavigationController:self.navigationController
                                                   animated:YES];
}


//^(BOOL success, id responce, NSError *error)

@end
