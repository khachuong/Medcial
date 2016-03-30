//
//  GLEListDoctorsViewController.m
//  Medcial
//
//  Created by Khachuong on 7/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEListDoctorsViewController.h"

@interface GLEListDoctorsViewController ()

@end

@implementation GLEListDoctorsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFUser query];
        [query whereKey:@"hospitalID" equalTo:_hospitalID];
        [query whereKey:@"department" equalTo:_departmentID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listDoctors = objects;
            [_tblListDoctors reloadData];
        }];
    });
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"Doctors";
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listDoctors count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DoctorsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *obj =  [_listDoctors objectAtIndex:indexPath.row];
    UIImageView *avatar =  (UIImageView *)[cell viewWithTag:100];
    PFFile *userImageFile = obj[@"avatar"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            avatar.image = image;
            avatar.layer.borderWidth = 3.0f;
            
            avatar.layer.borderColor = [UIColor whiteColor].CGColor;
            
            avatar.layer.cornerRadius = avatar.frame.size.height /2;
            avatar.layer.masksToBounds = YES;
            avatar.layer.borderWidth = 0;
        }
    }];
    UILabel *fullName = (UILabel *)[cell viewWithTag:101];
    fullName.text = obj[@"fullName"];
     UILabel *doctorQualification = (UILabel *)[cell viewWithTag:102];
    PFQuery *qualification = [PFQuery queryWithClassName:@"Qualification"];
    [qualification getObjectInBackgroundWithId:obj[@"qualification"] block:^(PFObject *object, NSError *error) {
        doctorQualification.text = [NSString stringWithFormat:@"Qualification: %@", object[@"qualificationName"]];
    }];
    UILabel *experience = (UILabel *)[cell viewWithTag:103];
    PFQuery *queryPoint = [PFQuery queryWithClassName:@"UserPoints"];
    [queryPoint whereKey:@"username" equalTo:obj[@"username"]];
    [queryPoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        int currentPoints = [object[@"points"] intValue];
        experience.text = [NSString stringWithFormat:@"Experiment: %d", currentPoints];
    }];
    return cell;
}


@end
