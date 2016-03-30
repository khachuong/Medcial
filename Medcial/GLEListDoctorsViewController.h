//
//  GLEListDoctorsViewController.h
//  Medcial
//
//  Created by Khachuong on 7/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GLEListDoctorsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblListDoctors;
@property (strong, nonatomic) NSString *departmentID;
@property (strong, nonatomic) NSString *hospitalID;
@property (strong, nonatomic) NSArray *listDoctors;
@end
