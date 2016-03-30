//
//  GLEListQuestionsViewController.h
//  Medcial
//
//  Created by Khachuong on 6/22/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLEListQuestionsViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tbListQuestions;
@property (strong, nonatomic) NSString *diseaseID;
@property (strong, nonatomic) NSArray *listQuestions;
@property (strong, nonatomic) UIImage *userAvat;
- (IBAction)refreshWasPressed:(id)sender;
@end
