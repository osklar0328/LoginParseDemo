//
//  SignUpViewController.m
//  ParseDemoStart
//
//  Created by Oskar Larsson on 2015-09-06.
//  Copyright (c) 2015 Oskar Larsson. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "HomeViewController.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signUpAction:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sign up action

// Sign up to Parse.
- (IBAction)signUpAction:(UIButton *)sender {
    NSString *email = self.emailTextField.text;
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *finalEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([username length] < 3) {
        // To short username.
        [self alertControllerTitle:@"Invalid"
                           message:@"Username must be greater than 3 characters."
                      shouldSignUp:NO];
    } else if ([password length] < 8) {
        // To short password.
        [self alertControllerTitle:@"Invalid"
                           message:@"Password must be greater than 8 characters."
                      shouldSignUp:NO];
    } else if (![self validEmail:email]) {
        // Invalid email.
        [self alertControllerTitle:@"Invalid"
                           message:@"Please enter a valid email address."
                      shouldSignUp:NO];
    } else {
        // Run a spinner to show a task in progress.
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        [spinner startAnimating];
        
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = finalEmail;
        
        // Sign up the user asynchronously.
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Sign up success.
                [self alertControllerTitle:@"Success"
                                   message:@"Signed up!"
                              shouldSignUp:YES];
            } else {
                // Sign up error.
                [self alertControllerTitle:@"Error"
                                   message:[error userInfo][@"error"]
                              shouldSignUp:NO];
            }
        }];
    }
}

#pragma mark - Alert controller

// UIAlertController with title, message and action.
- (void)alertControllerTitle:(NSString *)title message:(NSString *)message shouldSignUp:(BOOL)shouldSignUp {
    // Dissmiss any active keyboard.
    [self.view endEditing:YES];

    // Alert controller.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // Ok action.
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   if (shouldSignUp) {
                                                       // Present the home view controller on ok action click.
                                                       HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
                                                       [self presentViewController:homeViewController animated:YES completion:nil];
                                                   } else {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }
                                               }];
    
    [alert addAction:ok];
    
    // Present alert controller.
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Validate email

// Validate email from user input.
- (BOOL)validEmail:(NSString*) emailString {
    if([emailString length] == 0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    if (regExMatches == 0) {
        [self.emailTextField becomeFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

@end
