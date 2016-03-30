//
//  GLEUserQuestionsViewController.m
//  Medcial
//
//  Created by Khachuong on 7/14/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEUserQuestionsViewController.h"
#import "GLEShowUserQuestionViewController.h"
@interface GLEUserQuestionsViewController ()

@end

@implementation GLEUserQuestionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *queryQuestion = [PFQuery queryWithClassName:@"Question"];
        [queryQuestion whereKey:@"username" equalTo:[[PFUser currentUser] username]];
        [queryQuestion orderByDescending:@"updateAt"];
        [queryQuestion findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listQuestion = objects;
            [_tblQuestions reloadData];
        }];
    });
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"List of questions"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"List of questions"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listQuestion count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"questionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *question = [_listQuestion objectAtIndex:indexPath.row];
    UILabel *title = (UILabel *)[cell viewWithTag:100];
    title.text = question[@"title"];
    UILabel *time = (UILabel *)[cell viewWithTag:102];
    time.text = question[@"time"];
    UILabel *counter = (UILabel *)[cell viewWithTag:101];
    PFQuery *answers = [PFQuery queryWithClassName:@"Answer"];
    [answers whereKey:@"questionID" equalTo:question.objectId];
    [answers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        counter.text = [NSString stringWithFormat:@"%tu", [objects count]];
    }];
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [_tblQuestions indexPathForSelectedRow];
    PFObject *question = [_listQuestion objectAtIndex:indexPath.row];
    if([segue.identifier isEqualToString:@"showQuestionsDetails"]){
        GLEShowUserQuestionViewController *viewController = (GLEShowUserQuestionViewController *)segue.destinationViewController;
        viewController.questionID = question.objectId;
    }
}

- (IBAction)backWasPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
