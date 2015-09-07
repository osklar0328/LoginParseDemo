//
//  HomeViewController.m
//  ParseDemoStart
//
//  Created by Oskar Larsson on 2015-09-06.
//  Copyright (c) 2015 Oskar Larsson. All rights reserved.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

- (IBAction)logOutAction:(UIButton *)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Show the current visitor's username
    if ([PFUser currentUser].username) {
        // Add "@" before the username
        self.usernameLabel.text = [NSString stringWithFormat:@"@%@", [PFUser currentUser].username];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Present the login view controller if the user is not logged in.
    if ([PFUser currentUser] == nil) {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Log out

// Log out current user from Parse.
- (IBAction)logOutAction:(UIButton *)sender {
    // Log out the user asynchronously.
    [PFUser logOutInBackground];
    
    // Present the login screen.
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

@end
