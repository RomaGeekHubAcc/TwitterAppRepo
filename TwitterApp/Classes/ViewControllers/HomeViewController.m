//
//  HomeViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//



#import "TwitterAPIManager.h"
#import "LoginModalViewController.h"

#import "HomeViewController.h"


@interface HomeViewController ()

@end


@implementation HomeViewController


-(void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![TwitterAPIManager sharedInstance].userName) {
        [self presentLoginViewControllerForNavigationController:self.navigationController
                                                       animated:YES];
    }
}


#pragma mark - Private methods

-(void) presentLoginViewControllerForNavigationController:(UINavigationController*)navigationController animated:(BOOL)animated {
    LoginModalViewController *loginModalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginModalViewController"];
    loginModalVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [navigationController presentViewController:loginModalVC animated:animated completion:nil];
}

@end
