//
//  GLEUpdateQuestionViewController.h
//  Medcial
//
//  Created by Khachuong on 6/27/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
@interface GLEUpdateQuestionViewController : UIViewController
@property (strong, nonatomic) NSString *questionID;
@property (strong, nonatomic) NSString *oldTitle;
@property (strong, nonatomic) NSString *oldContent;
@property (strong, nonatomic) JVFloatLabeledTextField *titleField;
@property (strong, nonatomic) JVFloatLabeledTextView *descriptionField;
- (IBAction)cancelWasPressed:(id)sender;
- (IBAction)saveWasPressed:(id)sender;
@end
