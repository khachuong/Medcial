//
//  GLEFollowingDiseasViewController.m
//  Medcial
//
//  Created by Khachuong on 6/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEFollowingDiseasViewController.h"
#import "GLEShowUserQuestionViewController.h"
#import "IQKeyboardManager.h"
#import <Parse/Parse.h>
@interface GLEFollowingDiseasViewController ()

@end

@implementation GLEFollowingDiseasViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"FollowQuestion"];
        [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error){
                _listFollowedQuestions = objects;
                [_tblQuestions reloadData];
            }
        }];
        
    });
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"Following Questions"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];

    [self.tabBarController.tabBar setHidden:NO];

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewDidLoad];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self viewDidLoad];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listFollowedQuestions count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 118;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FollowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *question = [_listFollowedQuestions objectAtIndex:indexPath.row];
    NSString *questionID = question[@"questionID"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Question"];
        [query whereKey:@"objectId" equalTo:questionID];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
            UILabel *questionTitle = (UILabel *)[cell viewWithTag:102];
            questionTitle.text = obj[@"title"];
            UILabel *time = (UILabel *)[cell viewWithTag:103];
            time.text = obj[@"time"];
            
            UILabel *username = (UILabel *)[cell viewWithTag:101];
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
            
            BOOL check =[obj[@"isHideName"] boolValue ];
            if(check == YES){
                username.text = @"Anonymous";
                imageView.image = [UIImage imageNamed:@"icn_noimage.png"];
            }else{
                username.text = obj[@"username"];
                PFQuery *user = [PFUser query];
                [user whereKey:@"username" equalTo:obj[@"username"]];
                [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if(!error){
                        PFUser *gotUser = (PFUser *)object;
                        PFFile *userImageFile = gotUser[@"avatar"];
                        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:imageData];
                                _userAvat = image;
                                imageView.image = image;
                            }
                        }];
                        imageView.layer.borderWidth = 3.0f;
                        
                        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
                        
                        imageView.layer.cornerRadius = imageView.frame.size.height /2;
                        imageView.layer.masksToBounds = YES;
                        imageView.layer.borderWidth = 0;
                    }
                }];
                
            }
            UILabel *numberQuestions = (UILabel *)[cell viewWithTag:104];
            
            PFQuery *answers = [PFQuery queryWithClassName:@"Answer"];
            [answers whereKey:@"questionID" equalTo:obj.objectId];
            [answers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                numberQuestions.text = [NSString stringWithFormat:@"%tu", [objects count]];
                
            }];
            
            
        }];
    });
    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //followShowQuestion
    NSIndexPath *indexPath = [_tblQuestions indexPathForSelectedRow];
    PFObject *question = [_listFollowedQuestions objectAtIndex:indexPath.row];
    
    NSString *questionID = question[@"questionID"];
    if([segue.identifier isEqualToString:@"followShowQuestion"]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            GLEShowUserQuestionViewController *show = segue.destinationViewController;
            show.questionID = questionID;
        });
        
    }
    
}
@end
