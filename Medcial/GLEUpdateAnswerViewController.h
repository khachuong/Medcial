//
//  GLEUpdateAnswerViewController.h
//  Medcial
//
//  Created by Khachuong on 6/26/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
@interface GLEUpdateAnswerViewController : UIViewController<UITextViewDelegate>
- (IBAction)cancelWasPressed:(id)sender;
- (IBAction)saveWasPressed:(id)sender;
@property (strong, nonatomic) JVFloatLabeledTextField *titleField;
@property (strong, nonatomic) JVFloatLabeledTextView *descriptionField;
@property (strong, nonatomic) NSString *oldContents;
@property (strong, nonatomic) NSString *answerID;
@end
