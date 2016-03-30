//
//  GLEUserQuestionsViewController.h
//  Medcial
//
//  Created by Khachuong on 7/14/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GLEUserQuestionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblQuestions;
@property (strong, nonatomic) NSArray *listQuestion;
- (IBAction)backWasPressed:(id)sender;
@end
