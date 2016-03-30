//
//  GLEListHospitalViewController.m
//  Medcial
//
//  Created by Khachuong on 7/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEListHospitalViewController.h"
#import "GLEHospitalDetailViewController.h"

@interface GLEListHospitalViewController ()

@end

@implementation GLEListHospitalViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"List of Hospitals";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Hospital"];
        [query whereKey:@"provinceID" equalTo:_provinceID];
        [query orderByAscending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listHospitals = objects;
            [_tblHospitals reloadData];
        }];
    });
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listHospitals count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"hospitalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *obj = [_listHospitals objectAtIndex:indexPath.row];
    UILabel *name = (UILabel *)[cell viewWithTag:100];
    name.text = obj[@"name"];
    UILabel *address = (UILabel *)[cell viewWithTag:101];
    address.text = obj[@"address"];
    [address setLineBreakMode:NSLineBreakByWordWrapping];
    address.numberOfLines = 0;
    [address sizeToFit];
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [_tblHospitals indexPathForSelectedRow];
    PFObject *obj =  [_listHospitals objectAtIndex:indexPath.row];
    if([segue.identifier isEqualToString:@"showDetails"])
    {
        GLEHospitalDetailViewController *viewController = (GLEHospitalDetailViewController *)segue.destinationViewController;
        viewController.hospitalID = obj.objectId;
    }
}

@end
