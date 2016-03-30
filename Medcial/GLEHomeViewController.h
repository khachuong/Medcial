//
//  GLEHomeViewController.h
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface GLEHomeViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) NSArray *listDiseases;
@property (strong, nonatomic) NSArray *listDoctorsHospital;
@property (strong, nonatomic) IBOutlet UITableView *tbList;
@property (strong, nonatomic) NSArray *itemThumbnails;
@property (strong, nonatomic) NSArray *listItems;
@property (strong, nonatomic) NSArray *cellIdentifierItems;
@end
