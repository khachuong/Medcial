//
//  GLEListHospitalViewController.h
//  Medcial
//
//  Created by Khachuong on 7/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface GLEListHospitalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *provinceID;
@property (strong, nonatomic) NSArray *listHospitals;
@property (weak, nonatomic) IBOutlet UITableView *tblHospitals;

@end
