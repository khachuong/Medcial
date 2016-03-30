//
//  GLEForgotPasswordViewController.h
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLEForgotPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)sendPasswordWasPressed:(id)sender;

@end
