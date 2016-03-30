//
//  GLEListDoctorsHospitalViewController.h
//  Medcial
//
//  Created by Khachuong on 7/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface GLEListDoctorsHospitalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblHospitals;
@property (strong, nonatomic) NSArray *listAvailableHospitals;
@end
