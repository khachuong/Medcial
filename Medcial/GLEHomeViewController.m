//
//  GLEHomeViewController.m
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEHomeViewController.h"
#import "GLEAskQuetionViewController.h"
#import "GLEListDoctorsHospitalViewController.h"
#import <Parse/Parse.h>
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"

@interface GLEHomeViewController ()

@end

@implementation GLEHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _cellIdentifierItems = @[@"disease", @"doctors", @"hospital", @"information",@"knowledge"];
    _listItems = [NSArray arrayWithObjects:@"Các loại bệnh", @"Thông tin y tế", @"" ,@"Bác sỹ tư vấn", @"Bệnh viện", nil];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    PFUser *currentUser = [PFUser currentUser];
    if(!currentUser){
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    }
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"Medcial"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
    PFQuery *query = [PFQuery queryWithClassName:@"Diseases"];
    [query orderByAscending:@"diseaseName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.listDiseases = objects;
    }];
   

    self.tbList.separatorColor = [UIColor clearColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.revealViewController.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"Medcial"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listItems count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [_cellIdentifierItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
}
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tbList] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"showLogin"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }else if([segue.identifier isEqualToString:@"showAskQuestion"]){
        GLEAskQuetionViewController *askViewController =  (GLEAskQuetionViewController *)segue.destinationViewController;
        askViewController.listDiseases = self.listDiseases;
    }else if([segue.identifier isEqualToString:@"showDoctors"]){
        GLEListDoctorsHospitalViewController *doctorsViewController = (GLEListDoctorsHospitalViewController *)segue.destinationViewController;
    }
}

@end
