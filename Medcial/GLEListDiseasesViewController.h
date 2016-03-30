//
//  GLEListDiseasesViewController.h
//  Medcial
//
//  Created by Khachuong on 6/23/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLEListDiseasesViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tbListQuestions;
@property (nonatomic,strong) NSArray *listDiseases;
@property (nonatomic, strong) NSArray *numberOfQuestions;
- (IBAction)refreshWasPressed:(id)sender;
@end
