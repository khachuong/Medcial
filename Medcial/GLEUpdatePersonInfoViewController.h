//
//  GLEUpdatePersonInfoViewController.h
//  Medcial
//
//  Created by Khachuong on 6/18/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLEUpdatePersonInfoViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtBirth;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseImage;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *choosenImage;
- (IBAction)chooseImageWasPressed:(id)sender;
- (IBAction)cancelWasPressed:(id)sender;
- (IBAction)saveWasPressed:(id)sender;
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

@end
