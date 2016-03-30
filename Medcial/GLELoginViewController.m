//
//  GLELoginViewController.m
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLELoginViewController.h"
#import "GLESignUpViewController.h"
#import "GLEForgotPasswordViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "IQKeyboardManager.h"

@interface GLELoginViewController ()

@end

@implementation GLELoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    [[UIImage imageNamed:@"appbackground.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationItem.hidesBackButton = YES;
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}
- (IBAction)btnLoginWasPressed:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Singin in...";
    
    if([username length] == 0 || [password length] == 0){
        [hud hide:YES ];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must enter both two fields before signin!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [PFUser logInWithUsernameInBackground:[username lowercaseString]password:password block:^(PFUser *user, NSError *error) {
            [hud show:YES];
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Invalid username or password. Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            [hud hide:YES ];
        }];
    }
}

- (IBAction)btnForgotPasswordWasPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    GLEForgotPasswordViewController *viewController =
    [storyboard instantiateViewControllerWithIdentifier:@"GLEForgotPasswordViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnSignUpWasPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    GLESignUpViewController *viewController =
    [storyboard instantiateViewControllerWithIdentifier:@"GLESignUpViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
