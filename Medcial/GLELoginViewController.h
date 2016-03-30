//
//  GLELoginViewController.h
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLELoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)btnLoginWasPressed:(id)sender;
- (IBAction)btnForgotPasswordWasPressed:(id)sender;
- (IBAction)btnSignUpWasPressed:(id)sender;

@end
