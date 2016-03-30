//
//  GLEUpdateAnswerViewController.m
//  Medcial
//
//  Created by Khachuong on 6/26/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEUpdateAnswerViewController.h"
#import "GLEHomeViewController.h"
#import "IQKeyboardManager.h"
#import <Parse/Parse.h>

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 10.0f;
@interface GLEUpdateAnswerViewController ()

@end

@implementation GLEUpdateAnswerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    IQKeyboardManager *iq = [IQKeyboardManager sharedManager];
    iq.enable = YES;
    iq.enableAutoToolbar = YES;
    CGFloat topOffset = 0;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    [self.view setTintColor:[UIColor colorWithRed:79.0/255.0 green:219.0/255.0 blue:73.0/255.0 alpha:1.0f]];
    
    topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
#endif
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    _titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
                   CGRectMake(kJVFieldHMargin, topOffset, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    _titleField.placeholder = NSLocalizedString(@"Tiêu đề câu hỏi", @"");
    
    _titleField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _titleField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _titleField.floatingLabelTextColor = floatingLabelColor;
    _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_titleField];
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(0.0f, 64.0f, 320.0f, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    _descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
    _descriptionField.frame = CGRectMake(kJVFieldHMargin - _descriptionField.textContainer.lineFragmentPadding,
                                         div1.frame.origin.y + div1.frame.size.height,
                                         self.view.frame.size.width - 2*kJVFieldHMargin + _descriptionField.textContainer.lineFragmentPadding,
                                         kJVFieldHeight*5);
    
    
    _descriptionField.placeholder = NSLocalizedString(@"Nội dung chi tiết", @"");
    _descriptionField.text = _oldContents;
    _descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _descriptionField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:_descriptionField];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES; }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    IQKeyboardManager *iq = [IQKeyboardManager sharedManager];
    iq.enable = YES;
    iq.enableAutoToolbar = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)cancelWasPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)saveWasPressed:(id)sender {
    if([_descriptionField.text length] > 0)
    {
        PFQuery *updateQuery = [PFQuery queryWithClassName:@"Answer"];
        [updateQuery getObjectInBackgroundWithId:_answerID block:^(PFObject *object, NSError *error) {
            object[@"content"] = _descriptionField.text;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            
            object[@"time"] = dateString;
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!error){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Cập nhật câu trả lời của bạn thành công!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Không thể cập nhật câu trả lời của bạn khi câu trả lời mới không được điền vào!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
