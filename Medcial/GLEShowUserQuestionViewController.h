//
//  GLEShowUserQuestionViewController.h
//  Medcial
//
//  Created by Khachuong on 6/24/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "YFInputBar.h"

@interface GLEShowUserQuestionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate, UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbList;
@property (strong, nonatomic) NSArray *listAnswers;
@property (strong, nonatomic) NSMutableArray *listAllItems;
@property (strong, nonatomic) NSArray *cellItems;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *questionID;
@property (strong, nonatomic) NSString *descript;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *userAvat;
@property (strong, nonatomic) NSString *answerID;
@property (strong, nonatomic) YFInputBar * inputBar;
@property (strong, nonatomic) PFObject *currentQuestion;
@property (strong, nonatomic) NSString *chosenUsername;
@property NSString *questioner;
@property NSString *currentAnswerID;
@property NSString *currentID;
@property UIActionSheet *questionerPopup;
@property UIActionSheet *userPopup;
@property UIActionSheet *fullUserPopup;
- (IBAction)voteQuestionWasPressed:(id)sender;

- (IBAction)disVoteQuestionWasPressed:(id)sender;
- (IBAction)disVoteAnswerWasPressed:(id)sender;
- (IBAction)voteAnswerWasPressed:(id)sender;
- (IBAction)deleteQuestionWasPressed:(id)sender;
- (IBAction)refreshWasPressed:(id)sender;
- (IBAction)followWasPressed:(id)sender;
@end
