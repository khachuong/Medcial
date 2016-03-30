//
//  GLETimeLineViewController.h
//  Medcial
//
//  Created by Khachuong on 6/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GLETimeLineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblTimeline;
@property (strong, nonatomic) NSArray *listStatus;
@property (strong, nonatomic) NSString *currentName;
@property (strong, nonatomic) NSString *currentContent;
- (IBAction)postStatusWasPressed:(id)sender;

@end
