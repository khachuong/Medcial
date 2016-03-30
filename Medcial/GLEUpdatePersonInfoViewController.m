//
//  GLEUpdatePersonInfoViewController.m
//  Medcial
//
//  Created by Khachuong on 6/18/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEUpdatePersonInfoViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface GLEUpdatePersonInfoViewController ()

@end

@implementation GLEUpdatePersonInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    _txtUsername.text = [currentUser username];
    _txtEmail.text = [currentUser email];
    _txtPhone.text =currentUser[@"phone"];
    _txtFullName.text = currentUser[@"fullName"];
    _txtBirth.text = currentUser[@"dateOfBirth"];
    _txtAddress.text = currentUser[@"address"];
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    [[UIImage imageNamed:@"appbackground.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"My Profile"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    PFFile *userImageFile = currentUser[@"avatar"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [_avatar setImage:image];
        }
    }];
}
- (IBAction)chooseImageWasPressed:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptSource];
    }else{
        [self promtForPhotoRoll];
    }
}

- (IBAction)cancelWasPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveWasPressed:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    
    [currentUser setValue:_txtFullName.text forKey:@"fullName"];
    [currentUser setValue:_txtAddress.text forKey:@"address"];
    [currentUser setValue:_txtBirth.text forKey:@"dateOfBirth"];
    [currentUser setValue:_txtPhone.text forKey:@"phone"];
    if([_txtPassword.text length] > 0){
        [currentUser setValue:_txtPassword.text forKey:@"password"];
    }
    if(self.choosenImage != nil){
        UIImage *newImage = [self resizeImage:self.choosenImage toWidth:320.0f andHeight:480.0f];
        NSData *fileData; fileData = UIImagePNGRepresentation(newImage);
        NSString *fileName = @"avatar.png";
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        [currentUser setValue:file forKey:@"avatar"];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Vui lòng chờ";
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud show:YES];
        if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Update information successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        [hud hide:YES];
    }];
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

- (void) promptSource{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose avatar" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From photo library", @"Take a photo", nil];
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
    [_avatar setImage:image];
    self.choosenImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
