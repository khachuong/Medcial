//
//  GLEFollowingDiseasViewController.h
//  Medcial
//
//  Created by Khachuong on 6/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GLEFollowingDiseasViewController : UITableViewController
@property (strong, nonatomic) NSArray *listFollowedQuestions;
@property (strong, nonatomic) IBOutlet UITableView *tblQuestions;
@property (strong, nonatomic) UIImage *userAvat;
@end
