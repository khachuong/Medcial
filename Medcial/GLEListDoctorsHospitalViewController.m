//
//  GLEListDoctorsHospitalViewController.m
//  Medcial
//
//  Created by Khachuong on 7/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEListDoctorsHospitalViewController.h"
#import "GLEListDepartmentViewController.h"

@interface GLEListDoctorsHospitalViewController ()

@end

@implementation GLEListDoctorsHospitalViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    _listAvailableHospitals = [NSArray arrayWithObjects:@"oFGXfXHZRN",@"toRhkZ87NC", @"3W1vo7Kxq7", @"g021oZ4221", @"c7zGdTzuAB", nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"Hospital";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listAvailableHospitals count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier =  @"HospitalsDoctorCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *title = (UILabel *)[cell viewWithTag:100];
    UILabel *counter = (UILabel *)[cell viewWithTag:101];
    UIImageView *doctorIcon = (UIImageView *)[cell viewWithTag:102];
    doctorIcon.hidden = YES;
    UILabel *numberDoctorsTitle = (UILabel *)[cell viewWithTag:103];
    numberDoctorsTitle.hidden = YES;
     NSString *obj =  [_listAvailableHospitals objectAtIndex:indexPath.row];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *getHospital = [PFQuery queryWithClassName:@"Hospital"];
        [getHospital getObjectInBackgroundWithId:obj block:^(PFObject *object, NSError *error) {
            title.text = object[@"name"];
        }];
        PFQuery *getCounter = [PFUser query];
        [getCounter whereKey:@"hospitalID" equalTo:obj ];
        [getCounter findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            counter.text = [NSString stringWithFormat:@"%tu", [objects count]];
        }];
        doctorIcon.hidden = NO;
        numberDoctorsTitle.hidden = NO;
    });
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     NSIndexPath *indexPath = [_tblHospitals indexPathForSelectedRow];
    NSString *obj =  [_listAvailableHospitals objectAtIndex:indexPath.row];
    if([segue.identifier isEqualToString:@"showDepartment"]){
        GLEListDepartmentViewController *departments = (GLEListDepartmentViewController *)segue.destinationViewController;
        departments.hospitalID =obj;
    }
}


@end
