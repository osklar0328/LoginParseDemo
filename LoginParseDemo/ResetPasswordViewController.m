//
//  ResetPasswordViewController.m
//  ParseDemoStart
//
//  Created by Oskar Larsson on 2015-09-06.
//  Copyright (c) 2015 Oskar Larsson. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>

@interface ResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)passwordResetAction:(UIButton *)sender;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Password reset action

// Reset password with Parse.
- (IBAction)passwordResetAction:(UIButton *)sender {
    NSString *email = self.emailTextField.text;
    NSString *finalEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Send a request to reset a password asynchronously.
    [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
        if(!error) {
            [self alertControllerTitle:@"Password reset"
                               message:[NSString stringWithFormat:@"An email containing information on how to reset your password has been sent to %@", finalEmail]];
            
            // Clear email text field.
            self.emailTextField.text = @"";
        } else {
            [self alertControllerTitle:@"Error"
                               message:[error userInfo][@"error"]];
        }
    }];
}

#pragma mark - Alert controller

// UIAlertController with title, message.
- (void)alertControllerTitle:(NSString *)title message:(NSString *)message {
    // Dissmiss any active keyboard.
    [self.view endEditing:YES];
    
    // Alert controller.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // Ok action.
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    
    [alert addAction:ok];
    
    // Present alert controller.
    [self presentViewController:alert animated:YES completion:nil];
}

@end
