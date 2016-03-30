//
//  GLEListDepartmentViewController.m
//  Medcial
//
//  Created by Khachuong on 7/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEListDepartmentViewController.h"
#import "GLEListDoctorsViewController.h"

@interface GLEListDepartmentViewController ()

@end

@implementation GLEListDepartmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   self.navigationController.navigationBar.topItem.title = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Department"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listDepartments = objects;
            [_tblListDepartment reloadData];
        }];
    });
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"Departments";
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listDepartments count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"departmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *obj = [_listDepartments objectAtIndex:indexPath.row];
    cell.textLabel.text = obj[@"departmentName"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFUser query];
        [query whereKey:@"hospitalID" equalTo:_hospitalID];
        [query whereKey:@"department" equalTo:obj.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSString *counter = [NSString stringWithFormat:@"Doctors: %tu", [objects count]];
            cell.detailTextLabel.text = counter;
        }];
    });
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [_tblListDepartment indexPathForSelectedRow];
    PFObject *obj =  [_listDepartments objectAtIndex:indexPath.row];
    if([segue.identifier isEqualToString:@"showListDoctors"])
    {
        GLEListDoctorsViewController *listDoctorsViewController = (GLEListDoctorsViewController *)segue.destinationViewController;
        listDoctorsViewController.departmentID =  obj.objectId;
        listDoctorsViewController.hospitalID = _hospitalID;
    }
}
@end
