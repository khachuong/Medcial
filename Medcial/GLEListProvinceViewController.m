//
//  GLEListProvinceViewController.m
//  Medcial
//
//  Created by Khachuong on 7/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEListProvinceViewController.h"
#import "GLEListHospitalViewController.h"
@interface GLEListProvinceViewController ()

@end

@implementation GLEListProvinceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"List of Provinces";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Province"];
        [query orderByAscending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listProvinces = objects;
            [_tblProvinces reloadData];
        }];
    });
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listProvinces count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"provinceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *obj = [_listProvinces objectAtIndex:indexPath.row];
    UILabel *name = (UILabel *)[cell viewWithTag:100];
    UILabel *counter = (UILabel *)[cell viewWithTag:101];
    name.text = obj[@"provinceName"];
    PFQuery *query = [PFQuery queryWithClassName:@"Hospital"];
    [query whereKey:@"provinceID" equalTo:obj.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        counter.text = [NSString stringWithFormat:@"Hospital: %tu", [objects count]];
    }];
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [_tblProvinces indexPathForSelectedRow];
    PFObject *obj = [_listProvinces objectAtIndex:indexPath.row];
    if([segue.identifier isEqualToString:@"showHospitals"]){
        GLEListHospitalViewController *viewController = (GLEListHospitalViewController *)segue.destinationViewController;
        viewController.provinceID = obj.objectId;
    }
}
@end
