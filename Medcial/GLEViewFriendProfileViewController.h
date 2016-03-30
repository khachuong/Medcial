//
//  GLEViewFriendProfileViewController.h
//  Medcial
//
//  Created by Khachuong on 7/12/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface GLEViewFriendProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblProfile;
@property (strong, nonatomic) NSArray *listQuestions;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) PFObject *user;
- (IBAction)addFriendWasPressed:(id)sender;
- (IBAction)backWasPressed:(id)sender;
@end
