//
//  LoginModalViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//

#import "TwitterAPIManager.h"

#import "LoginModalViewController.h"


@interface LoginModalViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)signIn:(id)sender;
- (IBAction)signInWith_iOS:(id)sender;

@end

@implementation LoginModalViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	
    self.loginTF.delegate = self;
    self.passwordTF.delegate = self;
    self.passwordTF.secureTextEntry = YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Action methods

- (IBAction)signIn:(id)sender {
    $l("----sign in button pressed");
}

- (IBAction)signInWith_iOS:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    __weak typeof(self) weakSelf = self;
    
    [[TwitterAPIManager sharedInstance] authorizeWithIOSAccountCompletion:^(BOOL success, id responce) {
        if (success) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            $l("\n\n----responce = %@", responce);
            [weakSelf dismissViewControllerAnimated:YES
                                         completion:NULL];
        }
    }];
}


#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        [_passwordTF becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}


@end
