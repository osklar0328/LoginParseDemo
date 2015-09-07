//
//  LoginViewController.m
//  ParseDemoStart
//
//  Created by Oskar Larsson on 2015-09-06.
//  Copyright (c) 2015 Oskar Larsson. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginAction:(UIButton *)sender;

@end

@implementation LoginViewController

- (IBAction)unwindToLogInScreen:(UIStoryboardSegue *)unwindSegue {}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login action

// Login to Parse.
- (IBAction)loginAction:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([username length] < 3) {
        // To short username.
        [self alertControllerTitle:@"Invalid"
                           message:@"Username must be greater than 3 characters."
                      shouldLogin:NO];
    } else if ([password length] < 8) {
        // To short password.
        [self alertControllerTitle:@"Invalid"
                           message:@"Password must be greater than 8 characters."
                      shouldLogin:NO];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Successfull login.
                                                [self alertControllerTitle:@"Success"
                                                                   message:@"Logged in!"
                                                               shouldLogin:YES];
                                            } else {
                                                // Login error.
                                                [self alertControllerTitle:@"Error"
                                                                   message:[error userInfo][@"error"]
                                                              shouldLogin:NO];
                                            }
                                            
                                            // Clear text fields.
                                            self.usernameTextField.text = @"";
                                            self.passwordTextField.text = @"";
                                        }];
    }
}

#pragma mark - Alert controller

// UIAlertController with title, message and action.
- (void)alertControllerTitle:(NSString *)title message:(NSString *)message shouldLogin:(BOOL)shouldLogin {
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
                                                   if (shouldLogin) {
                                                       // Present the home view controller on ok action click.
                                                       HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
                                                       [self presentViewController:homeViewController animated:YES completion:^{
                                                           // Clear textfields.
                                                           self.usernameTextField.text = @"";
                                                           self.passwordTextField.text = @"";
                                                       }];
                                                   } else {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }
                                               }];
    
    [alert addAction:ok];
    
    // Present alert controller.
    [self presentViewController:alert animated:YES completion:nil];
}

@end
