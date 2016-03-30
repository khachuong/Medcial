//
//  GLEAskQuetionViewController.h
//  Medcial
//
//  Created by Khachuong on 6/15/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
@interface GLEAskQuetionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecific;
@property (weak, nonatomic) IBOutlet UISwitch *hideNameSwitch;

@property (weak, nonatomic) IBOutlet UILabel *diseaseField;
@property (weak, nonatomic) IBOutlet UILabel *diseaseNameField;
@property (weak, nonatomic) IBOutlet UIPickerView *mypicker;
@property (weak, nonatomic) IBOutlet UIPickerView *diseasesPicker;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) JVFloatLabeledTextField *titleField;
@property (strong, nonatomic) JVFloatLabeledTextView *descriptionField;
@property (strong, nonatomic) NSArray *listDiseases;
@property (strong, nonatomic) NSArray *listDiseasesName;
@property (strong, nonatomic) PFObject *currentItem;

@property (strong, nonatomic) PFObject *currentDiseaseName;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *choosenImage;


- (IBAction)cancelWasPressed:(id)sender;
- (IBAction)saveWasPressed:(id)sender;
- (IBAction)showListDiseasesWasPressed:(id)sender;

- (IBAction)showPickerWasPressed:(id)sender;
- (IBAction)chooseImageWasPressed:(id)sender;
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;
@end
