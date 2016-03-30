//
//  GLEForgotPasswordViewController.m
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEForgotPasswordViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "GLELoginViewController.h"
#import "IQKeyboardManager.h"
@interface GLEForgotPasswordViewController ()

@end

@implementation GLEForgotPasswordViewController

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
    self.navigationItem.title = @"Forgot password";
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)sendPasswordWasPressed:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait";
    [PFUser requestPasswordResetForEmailInBackground:_emailField.text block:^(BOOL succeeded, NSError *error) {
        [hud show:YES];
        if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Please check your email inbox to get new password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        [hud hide:YES];
    }];
}
@end
