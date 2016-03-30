//
//  GLEListQuestionsViewController.m
//  Medcial
//
//  Created by Khachuong on 6/22/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEListQuestionsViewController.h"
#import "GLEShowUserQuestionViewController.h"
#import <Parse/Parse.h>

@interface GLEListQuestionsViewController ()

@end

@implementation GLEListQuestionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *questions = [PFQuery queryWithClassName:@"Question"];
        [questions orderByDescending:@"createdAt"];
        [questions whereKey:@"diseaseID" equalTo:_diseaseID];
        [questions findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listQuestions= objects;
            [self.tbListQuestions reloadData];
        }];
        
    });
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"List of questions";
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listQuestions count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 118;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"questionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *obj = [_listQuestions objectAtIndex:indexPath.row];
    UILabel *username = (UILabel *)[cell viewWithTag:101];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    BOOL check =[obj[@"isHideName"] boolValue ];
    if(check == YES){
        username.text = @"Anonymous";
        imageView.image = [UIImage imageNamed:@"icn_noimage.png"];
    }else{
        username.text = obj[@"username"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        });
    }
    UILabel *numberQuestions = (UILabel *)[cell viewWithTag:104];
    
    PFQuery *answers = [PFQuery queryWithClassName:@"Answer"];
    [answers whereKey:@"questionID" equalTo:obj.objectId];
    [answers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        numberQuestions.text = [NSString stringWithFormat:@"%tu", [objects count]];
        
    }];
    
    
    UILabel *questionTitle = (UILabel *)[cell viewWithTag:102];
    questionTitle.text = obj[@"title"];
    UILabel *time = (UILabel *)[cell viewWithTag:103];
    time.text = obj[@"time"];
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [_tbListQuestions indexPathForSelectedRow];
    PFObject *obj = [_listQuestions objectAtIndex:indexPath.row];
    if([segue.identifier isEqualToString:@"showUserQuestion"]){
        GLEShowUserQuestionViewController *show = segue.destinationViewController;
        show.questionID = obj.objectId;
    }
}
- (IBAction)refreshWasPressed:(id)sender {
    [self viewDidLoad];
}
@end
