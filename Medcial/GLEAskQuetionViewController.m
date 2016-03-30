//
//  GLEAskQuetionViewController.m
//  Medcial
//
//  Created by Khachuong on 6/15/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEAskQuetionViewController.h"
#import "IQKeyboardManager.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"


const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;
@interface GLEAskQuetionViewController ()

@end

@implementation GLEAskQuetionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageButton.hidden = YES;
    CGFloat topOffset = 0;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    [self.view setTintColor:[UIColor colorWithRed:79.0/255.0 green:219.0/255.0 blue:73.0/255.0 alpha:1.0f]];
    
    topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
#endif
    [_lblType setHidden:YES];
    [_lblSpecific setHidden:YES];
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    _titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
                   CGRectMake(kJVFieldHMargin, topOffset, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    _titleField.placeholder = NSLocalizedString(@"Question's title", @"");
    _titleField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _titleField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _titleField.floatingLabelTextColor = floatingLabelColor;
    _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_titleField];
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin, _titleField.frame.origin.y + _titleField.frame.size.height,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    
    
    _descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
    _descriptionField.frame = CGRectMake(kJVFieldHMargin - _descriptionField.textContainer.lineFragmentPadding,
                                         div1.frame.origin.y + div1.frame.size.height,
                                         self.view.frame.size.width - 2*kJVFieldHMargin + _descriptionField.textContainer.lineFragmentPadding,
                                         kJVFieldHeight*3);
    _descriptionField.placeholder = NSLocalizedString(@"Detail of your symstoms", @"");
    _descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _descriptionField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:_descriptionField];
    UIView *div2 = [UIView new];
    div2.frame = CGRectMake(kJVFieldHMargin, _descriptionField.frame.origin.y + _descriptionField.frame.size.height,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div2];
    [_titleField becomeFirstResponder];
    self.mypicker.hidden = YES;
    self.diseasesPicker.hidden = YES;
    self.mypicker.dataSource = self;
    self.mypicker.delegate = self;
    self.diseasesPicker.dataSource = self;
    self.diseasesPicker.delegate = self;
    [self.view addSubview:_mypicker];
    [_mypicker selectRow:2 inComponent:0 animated:YES];
    [self.view addSubview:_diseasesPicker];
    [_diseasesPicker selectRow:2 inComponent:0 animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    IQKeyboardManager *iq = [IQKeyboardManager sharedManager];
    iq.enable = YES;
    iq.enableAutoToolbar = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component{
    if(pickerView == _mypicker){
        return [self.listDiseases count];
    }else if(pickerView == _diseasesPicker){
        return [self.listDiseasesName count];
    }
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if(pickerView == _mypicker){
        PFObject *obj = [_listDiseases objectAtIndex:row];
        return obj[@"diseaseName"];
    } else if(pickerView == _diseasesPicker){
        PFObject *obj = [_listDiseasesName objectAtIndex:row];
        return obj[@"title"];
    }
    return nil;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView == _mypicker){
        PFObject *obj = [_listDiseases objectAtIndex:row];
        self.currentItem = obj;
        self.diseaseField.text = obj[@"diseaseName"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PFQuery *query = [PFQuery queryWithClassName:@"DiseasesList"];
            [query orderByAscending:@"title"];
            [query whereKey:@"diseaseID" equalTo:_currentItem.objectId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                self.listDiseasesName = objects;
                [self.diseasesPicker reloadAllComponents];
                self.mypicker.hidden = YES;
                [self.diseaseField setTextColor:[UIColor blackColor]];
                [_lblType setHidden:NO];
                
            }];
        });
    }else if(pickerView == _diseasesPicker){
        
        PFObject *obj = [_listDiseasesName objectAtIndex:row];
        self.currentDiseaseName = obj;
        self.diseaseNameField.text = obj[@"title"];
        self.diseasesPicker.hidden = YES;
        [self.diseaseNameField setTextColor:[UIColor blackColor]];
        [_lblSpecific setHidden:NO];
    }
    
}
- (IBAction)cancelWasPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.diseasesPicker.hidden = YES;
    self.mypicker.hidden = YES;
    [self.view endEditing:YES];
}
- (IBAction)saveWasPressed:(id)sender {
    
    if([_titleField.text length] == 0 ||[_descriptionField.text length] == 0 || _currentItem == nil || _currentDiseaseName == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You cannot leave tile, description and kind of disease blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PFUser *currentUser = [PFUser currentUser];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Please wait";
        PFObject *obj = [PFObject objectWithClassName:@"Question"];
        [obj setValue:_currentItem.objectId forKey:@"diseaseID"];
        [obj setValue:_currentDiseaseName.objectId forKey:@"diseasesListObjectID"];
        [obj setValue:currentUser.username forKey:@"username"];
        [obj setValue:_titleField.text forKey:@"title"];
        [obj setValue:_descriptionField.text forKey:@"content"];
        if(_hideNameSwitch.isOn)
        {
            [obj setValue:@YES forKey:@"isHideName"];
        }
        else
        {
            [obj setValue:@NO forKey:@"isHideName"];
        }
        if(self.choosenImage != nil){
            
            UIGraphicsBeginImageContext(CGSizeMake(640, 960));
            [self.choosenImage drawInRect: CGRectMake(0, 0, 640, 960)];
            UIGraphicsEndImageContext();
            
            NSData *imageData = UIImageJPEGRepresentation(self.choosenImage, 0.05f);
            NSString *fileName = @"image.png";
            PFFile *file = [PFFile fileWithName:fileName data:imageData];
            
            [obj setValue:file forKey:@"image"];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        [obj setValue:dateString forKey:@"time"];
        
        PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
        [updatePoint whereKey:@"username" equalTo:[currentUser username]];
        [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if(!error){
                int oldPoints = [object[@"points"] intValue];
                [object setObject:[NSNumber numberWithInt:oldPoints+2] forKey:@"points"];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                }];
            }
        }];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud show:YES];
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Raise question successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            [hud hide:YES];
        }];
    }
}

- (IBAction)showListDiseasesWasPressed:(id)sender {
    self.mypicker.hidden = YES;
    [_diseasesPicker setBackgroundColor:[UIColor whiteColor]];
    self.diseasesPicker.hidden= [self.diseasesPicker isHidden] ? NO : YES;
}
- (IBAction)showPickerWasPressed:(id)sender {
    [_mypicker setBackgroundColor:[UIColor whiteColor]];
    self.diseasesPicker.hidden = YES;
    self.mypicker.hidden= [self.mypicker isHidden] ? NO : YES;
    
    
}
-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.choosenImage drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
- (IBAction)chooseImageWasPressed:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptSource];
    }else{
        [self promtForPhotoRoll];
    }
    
}
- (void) promptSource{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Chọn ảnh" delegate:self cancelButtonTitle:@"Hủy" destructiveButtonTitle:nil otherButtonTitles:@"Chọn từ thư viện", @"Chụp 1 bức ảnh", nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != actionSheet.cancelButtonIndex){
        if(buttonIndex != actionSheet.firstOtherButtonIndex){
            [self promtForCamera];
        }else{
            [self promtForPhotoRoll];
        }
    }
}

- (void) promtForCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) promtForPhotoRoll{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.imageButton setImage:image forState:UIControlStateNormal];
    self.choosenImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
