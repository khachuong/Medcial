//
//  GLESignUpViewController.m
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLESignUpViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "IQKeyboardManager.h"
@interface GLESignUpViewController ()

@end

@implementation GLESignUpViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationController.navigationBar.topItem.title = @"";
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"appbackground.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Signup new account";
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)btnSignUpWasPressed:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phone = [self.mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait";
    if([username length] == 0 || [password length] == 0 || [email length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"All fields cannot be empty. Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        PFUser *newUser = [PFUser user];
        newUser.username = [username lowercaseString];
        newUser.password = password;
        newUser.email = email;
        newUser[@"phone"] = phone;
        PFObject *point = [PFObject objectWithClassName:@"UserPoints"];
        [point setValue:[username lowercaseString] forKey:@"username"];
        [point setValue:@1 forKey:@"points"];
        [point saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        }];
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud show:YES];
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Signup new account successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            [hud hide:YES];
        }];
    }
}
@end
