//
//  GLESignUpViewController.h
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLESignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
- (IBAction)btnSignUpWasPressed:(id)sender;

@end
