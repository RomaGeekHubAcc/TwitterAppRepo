//
//  LoginModalViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//

#import "TwitterAPIManager.h"

#import "LoginModalViewController.h"


@interface LoginModalViewController () <UIWebViewDelegate>


- (IBAction)signIn:(id)sender;
- (IBAction)signInWith_iOS:(id)sender;

@end

@implementation LoginModalViewController

-(void)viewDidLoad {
    [super viewDidLoad];

}
#error прибрати поки що авторизацію з ios

#pragma mark - Action methods

- (IBAction)signIn:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[TwitterAPIManager sharedInstance] authrizeWithWebBrowserWithComlition:^(BOOL success, id responce, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (success) {
            NSURL *url = (NSURL *)responce;
            if (url) {
                [self openWebViewWithUrl:url];
            }
            
        } else {
            $l("Error - %@", error);
        }
    }];
}

- (IBAction)signInWith_iOS:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    __weak typeof(self) weakSelf = self;
    
    [[TwitterAPIManager sharedInstance] authorizeWithIOSAccountCompletion:^(BOOL success, id responce, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (success) {
            $l("\n\n----responce = %@", responce);
            [weakSelf dismissViewControllerAnimated:YES
                                         completion:NULL];
        }
        else {
            [self showAlertViewNotFindAccount];
            $l("\n\n--->Показати алерт про те, що настройок не знайдено");
        }
    }];
}


#pragma mark - Private methods

-(void) showAlertViewNotFindAccount {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Нема Акаунта!" message:@"Потрібно зайти в Settings і авторизуватись!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void) openWebViewWithUrl:(NSURL *)url {
    UIWebView *browser = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [browser loadRequest:request];
    browser.delegate = self;
    [self.view addSubview:browser];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    NSString *urlScheme = [url scheme];
    $l(@"Loading URL: %@", [url absoluteString]);
    
    if ([urlScheme isEqualToString:@"myapprr"]) {
        [webView removeFromSuperview];
        
        NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
//        NSString *token = d[@"oauth_token"];
        NSString *verifier = d[@"oauth_verifier"];
        
        __weak typeof(self) weakSelf = self;
        
        [[TwitterAPIManager sharedInstance] sendOauthVerifier:verifier
                                                   complition:^(BOOL success, id responce, NSError *error) {
                                                       if (success) {
                                                           [weakSelf dismissViewControllerAnimated:YES
                                                                                        completion:NULL];
                                                       } else {
                                                           $l("Error - %@", error);
                                                       }
                                                   }];
    }
    return YES;
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


@end
