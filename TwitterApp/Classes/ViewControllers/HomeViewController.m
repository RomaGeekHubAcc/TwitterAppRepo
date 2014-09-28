//
//  HomeViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//


#import "TwitterAPIManager.h"
#import "TweetTableViewCell.h"

#import "HomeViewController.h"


@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *tweetItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutOutlet;

-(IBAction) loginLogout:(id)sender;

@end


@implementation HomeViewController


-(void)viewDidLoad {
    [super viewDidLoad];
	
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.logoutOutlet setTitle:@"Log In" forState:UIControlStateNormal];
    
#warning перевірка інет-з"єднання..
    NSString *verifier = [[NSUserDefaults standardUserDefaults] objectForKey:TWITTER_API_OAUTH_SECRET_KEY];
    if (verifier) {
        [[TwitterAPIManager sharedInstance] onlyAutentificationWithCompletion:^(BOOL success, id responce, NSError *error) {
            if (success) {
                [TwitterAPIManager sharedInstance].isAuthorized = YES;
                [TwitterAPIManager sharedInstance].userName = (NSString *)responce;
#warning задавати тайтл for UIBarButtonItem
                [self.logoutOutlet setTitle:@"Log Out" forState:UIControlStateNormal];
                [self getHomeTimeline];
            }
        }];
    } else {
        [self.logoutOutlet setTitle:@"Log In" forState:UIControlStateNormal];
        [self loginLogout:nil];
    }
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


#pragma mark - Private methods

//-(void) oauth {
//    [[TwitterAPIManager sharedInstance] onlyAutentificationWithCompletion:^(BOOL success, id responce, NSError *error) {
//        if (success) {
//            [self getHomeTimeline];
//            self.logoutOutlet.title = @"Log Out";
//        }
//        else {
//            $l("---oauth error -> %@", [error localizedDescription]);
//        }
//    }];
//}

-(void) loginWithWebBrowser {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[TwitterAPIManager sharedInstance] authrizeWithWebBrowserWithComlition:^(BOOL success, id responce, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (success) {
            NSURL *url = (NSURL *)responce;
            if (url) {
                [self openWebViewWithUrl:url];
            }
            
        } else {
            $l("--loginWithWebBrowser Error - %@", error);
        }
    }];
}

-(void) getHomeTimeline {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[TwitterAPIManager sharedInstance] getHomeTimelineSinceId:nil
                                                         count:TWEETS_COUNT
                                               completionBlock:^(BOOL success, id responce, NSError *error){
                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                   if (success) {
                                                       self.tweetItems = [NSMutableArray arrayWithArray:responce];
                                                       [self.tableView reloadData];
                                                   }
                                                   else {
                                                       $l("Error - %@", error);
                                                   }
                                               }];
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

-(void) openWebViewWithUrl:(NSURL *)url {
    UIWebView *browser = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [browser loadRequest:request];
    browser.delegate = self;
    [self.view addSubview:browser];
}


#pragma mark - UITableViewDataSouce methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetItems count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    if (!cell) {
        cell = [[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"TweetTableViewCell"];
    }
    NSDictionary *tweet = self.tweetItems[indexPath.row];
    
    [cell setContentWithDicctionary:tweet];
    
    return cell;
}

#pragma mark - Delegated methods - UIWebViewDelegate

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    NSString *urlScheme = [url scheme];
    $l(@"Loading URL: %@", [url absoluteString]);
    
    if ([urlScheme isEqualToString:@"myapprr"]) {
        [self.logoutOutlet setTitle:@"Log Out" forState:UIControlStateNormal];
        [webView removeFromSuperview];
        
        NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
        NSString *verifier = d[@"oauth_verifier"];
        
        [[TwitterAPIManager sharedInstance] sendOauthVerifier:verifier
                                                   complition:^(BOOL success, id responce, NSError *error) {
                                                       if (success) {
                                                           [self getHomeTimeline];
                                                       } else {
                                                           $l("Error - %@", error);
                                                       }
                                                   }];
    }
    return YES;
}


#pragma mark - Action methods

-(IBAction) loginLogout:(id)sender {
    if ([TwitterAPIManager sharedInstance].isAuthorized) {
        self.tweetItems = nil;
        [self.tableView reloadData];
        [self.logoutOutlet setTitle:@"Log In" forState:UIControlStateNormal];
        [[TwitterAPIManager sharedInstance] finishTwitterSession];
    } else {
        [self loginWithWebBrowser];
    }
    
}


//^(BOOL success, id responce, NSError *error)

@end
