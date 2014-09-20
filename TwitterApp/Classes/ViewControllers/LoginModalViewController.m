//
//  LoginModalViewController.m
//  TwitterApp
//
//  Created by Roma on 17.09.14.
//
//



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
}

- (IBAction)signInWith_iOS:(id)sender {
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
