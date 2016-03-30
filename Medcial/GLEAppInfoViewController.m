//
//  GLEAppInfoViewController.m
//  Medcial
//
//  Created by Khachuong on 7/14/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEAppInfoViewController.h"

@interface GLEAppInfoViewController ()

@end

@implementation GLEAppInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _txtContent.text = @"Ứng dụng Medcial được phát triển bởi Nguyễn Khả Chương - 2014. Bản quyền thuộc về Nguyễn Khả Chương - mọi sao chép hay phát tán thông tin mà chưa được tác giả đồng ý sẽ bị xem như là vi phạm, và có thể phải chịu trách nhiệm trước pháp luật. Ứng dụng Medcial sử dụng một số bản thiết kế, icon, api của các trang chia sẻ và Medcial có toàn quyền sử dụng trong mục đích cá nhân cũng như trong thương mại. Bản thiết kế được tùy chỉnh và sử dụng từ các nguồn: Dribbble.com, Esignzway.com, Freepik. Medcial cũng sử dụng các source code tích hợp của bên thứ 3 là IQKeyBoardManager, JVFloatLabeledTextField, YFInput, MBProgressHUD, SWRevealViewController. Mọi khiếu nại xin vui lòng liên hệ: khachuongvn@hotmail.com - 01674647306";
    _txtContent.textAlignment = NSTextAlignmentJustified;
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"App Information"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"App Information"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
}


- (IBAction)backWasPressed:(id)sender {
       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
