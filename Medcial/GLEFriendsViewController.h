//
//  GLEFriendsViewController.h
//  Medcial
//
//  Created by Khachuong on 7/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface GLEFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblFriends;
@property (strong, nonatomic) NSArray *listFriends;
- (IBAction)backWasPressed:(id)sender;
- (IBAction)acceptFriendWasPressed:(id)sender;
- (IBAction)cancelWasPressed:(id)sender;
@end
