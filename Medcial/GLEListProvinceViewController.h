//
//  GLEListProvinceViewController.h
//  Medcial
//
//  Created by Khachuong on 7/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GLEListProvinceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *listProvinces;
@property (weak, nonatomic) IBOutlet UITableView *tblProvinces;
@end
