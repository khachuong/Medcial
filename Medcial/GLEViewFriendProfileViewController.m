//
//  GLEViewFriendProfileViewController.m
//  Medcial
//
//  Created by Khachuong on 7/12/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEViewFriendProfileViewController.h"
#import "GLEShowUserQuestionViewController.h"

@interface GLEViewFriendProfileViewController ()

@end

@implementation GLEViewFriendProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:_username];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            _user = object;
        }];
        PFQuery *queryQuestion = [PFQuery queryWithClassName:@"Question"];
        [queryQuestion whereKey:@"username" equalTo:_username];
        [queryQuestion whereKey:@"isHideName" equalTo:@NO];
        [queryQuestion orderByDescending:@"createdAt"];
        [queryQuestion findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listQuestions = objects;
            [_tblProfile reloadData];
        }];
    });
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 214;
    }else if(indexPath.section == 1)
    {
        return 142;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return [_listQuestions count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 40;
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return @"Questions";
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        NSString *CellIdentifier = @"profile";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *avatar = (UIImageView *)[cell viewWithTag:100];
        UILabel *lblUsername = (UILabel *)[cell viewWithTag:101];
        UILabel *lblExperiences = (UILabel *) [cell viewWithTag:102];
        UILabel *numberOfAsked = (UILabel *) [cell viewWithTag:104];
        UILabel *numberOfAnswered = (UILabel *) [cell viewWithTag:103];
        UILabel *numberOfFriends = (UILabel *) [cell viewWithTag:105];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PFFile *userImageFile = _user[@"avatar"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    avatar.image = image;
                    avatar.layer.borderWidth = 3.0f;
                    
                    avatar.layer.borderColor = [UIColor whiteColor].CGColor;
                    
                    avatar.layer.cornerRadius = avatar.frame.size.height /2;
                    avatar.layer.masksToBounds = YES;
                    avatar.layer.borderWidth = 0;
                }
            }];
        });

        NSString *currentName = [[PFUser currentUser] username];
        PFQuery *checkFriend = [PFQuery queryWithClassName:@"Friends"];
        [checkFriend whereKey:@"username" equalTo:currentName];
        [checkFriend whereKey:@"friendName" equalTo:_username];
        [checkFriend getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if(object != nil){
                UIImageView *addIcon = (UIImageView *)[cell viewWithTag:106];
                UIButton *btnAdd = (UIButton *)[cell viewWithTag:107];

                addIcon.hidden = YES;
                btnAdd.hidden = YES;
                bool isFriend =  [object[@"isFriend"] boolValue];
                if(isFriend){
                    UILabel *friend = (UILabel *)[cell viewWithTag:109];
                    friend.hidden = NO;
                }else{
                    UILabel *waiting = (UILabel *)[cell viewWithTag:108];
                    waiting.hidden = NO;
                }
            }else{
                UIImageView *addIcon = (UIImageView *)[cell viewWithTag:106];
                UIButton *btnAdd = (UIButton *)[cell viewWithTag:107];
                addIcon.hidden = NO;
                btnAdd.hidden = NO;
            }
        }];
        lblUsername.text = _username;
        PFQuery *queryFriends = [PFQuery queryWithClassName:@"Friends"];
        [queryFriends whereKey:@"username" equalTo:currentName];
        [queryFriends whereKey:@"friendName" equalTo:_username];
        [queryFriends whereKey:@"isFriend" equalTo:@YES];
        [queryFriends findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            numberOfFriends.text = [NSString stringWithFormat:@"Friends         %tu", [objects count]];
        }];
        PFQuery *queryAsked = [PFQuery queryWithClassName:@"Question"];
        [queryAsked whereKey:@"username" equalTo:_username];
        [queryAsked findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            numberOfAsked.text = [NSString stringWithFormat:@"Asked              %tu", [objects count]];
        }];
        PFQuery *queryAnswer =  [PFQuery queryWithClassName:@"Answer"];
        [queryAnswer whereKey:@"username" equalTo:_username];
        [queryAnswer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            numberOfAnswered.text =[NSString stringWithFormat:@"Answered       %tu", [objects count]];
        }];
        PFQuery *queryPoint = [PFQuery queryWithClassName:@"UserPoints"];
        [queryPoint whereKey:@"username" equalTo: _username];
        [queryPoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            int currentPoints = [object[@"points"] intValue];
            lblExperiences.text = [NSString stringWithFormat:@"Experiment: %d", currentPoints];
        }];
        return cell;
    }else if(indexPath.section == 1){
        NSString *CellIdentifier = @"question";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PFObject *question = [_listQuestions objectAtIndex:indexPath.row];
        UILabel *questionTitle = (UILabel *)[cell viewWithTag:200];
        UILabel *questionTime = (UILabel *)[cell viewWithTag:201];
        UILabel *questionDisease = (UILabel *)[cell viewWithTag:202];
        UITextView *questionDescription = (UITextView *)[cell viewWithTag:203];
        
        questionTitle.text = question[@"title"];
        questionTime.text = question[@"time"];
        questionDescription.text = question[@"content"];
        questionDescription.textAlignment = NSTextAlignmentJustified;
        questionDescription.editable = NO;
        questionDescription.selectable = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PFQuery *query = [PFQuery queryWithClassName:@"DiseasesList"];
            [query whereKey:@"objectId" equalTo:question[@"diseasesListObjectID"]];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                questionDisease.text = object[@"title"];
            }];
        });
        return cell;
    }
    return nil;
}

- (IBAction)addFriendWasPressed:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    NSString *currentName = [[PFUser currentUser] username];
    [query whereKey:@"username" equalTo:currentName];
    [query whereKey:@"friendName" equalTo:_username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(object == nil){
            PFObject *obj = [PFObject objectWithClassName:@"Friends"];
            [obj setObject:currentName forKey:@"username"];
            [obj setObject:_username forKey:@"friendName"];
            [obj setObject:@NO forKey:@"isFriend"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            [obj setValue:dateString forKey:@"time"];
            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [_tblProfile reloadData];
            }];
        }
    }];
}

- (IBAction)backWasPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [_tblProfile indexPathForSelectedRow];
    PFObject *question = [_listQuestions objectAtIndex:indexPath.row];
    if([segue.identifier isEqualToString:@"showUserQuestionSegue"])
    {
        GLEShowUserQuestionViewController *show = segue.destinationViewController;
        show.questionID = question.objectId;
    }
}
@end
