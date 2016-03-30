//
//  GLETimeLineViewController.m
//  Medcial
//
//  Created by Khachuong on 6/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLETimeLineViewController.h"
#import "IQKeyboardManager.h"
@interface GLETimeLineViewController ()

@end

@implementation GLETimeLineViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentName = [[PFUser currentUser] username];
    self.navigationController.navigationBar.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *queryStatus = [PFQuery queryWithClassName:@"Status"];
        [queryStatus whereKey:@"username" equalTo:_currentName];
        [queryStatus orderByDescending:@"createdAt"];
        [queryStatus findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listStatus = objects;
            [_tblTimeline reloadData];
        }];
    });
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"My Dashboard"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 214;
    }else if(indexPath.section == 1)
    {
        return 32;
    }else if(indexPath.section == 2){
        return 100;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }else if(section == 2){
        return [_listStatus count];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFUser *currentUser = [PFUser currentUser];
    if(indexPath.section == 0){
        NSString *CellIdentifier = @"info";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *avatar = (UIImageView *)[cell viewWithTag:100];
        UILabel *lblUsername = (UILabel *)[cell viewWithTag:101];
        UILabel *lblExperiences = (UILabel *) [cell viewWithTag:102];
        UILabel *numberOfAsked = (UILabel *) [cell viewWithTag:104];
    
        UILabel *numberOfAnswered = (UILabel *) [cell viewWithTag:110];
        UILabel *numberOfFriends = (UILabel *) [cell viewWithTag:105];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            lblUsername.text = _currentName;
            PFQuery *queryFriends = [PFQuery queryWithClassName:@"Friends"];
            [queryFriends whereKey:@"username" equalTo:_currentName];
            [queryFriends whereKey:@"isFriend" equalTo:@YES];
            [queryFriends findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                numberOfFriends.text = [NSString stringWithFormat:@"Friends         %tu", [objects count]];
            }];
            PFQuery *queryAsked = [PFQuery queryWithClassName:@"Question"];
            [queryAsked whereKey:@"username" equalTo:_currentName];
            [queryAsked findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                numberOfAsked.text = [NSString stringWithFormat:@"Asked               %tu", [objects count]];
            }];
            PFQuery *queryAnswer =  [PFQuery queryWithClassName:@"Answer"];
            [queryAnswer whereKey:@"username" equalTo:_currentName];
            [queryAnswer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                numberOfAnswered.text =[NSString stringWithFormat:@"Answered       %tu", [objects count]];
            }];
            PFQuery *queryPoint = [PFQuery queryWithClassName:@"UserPoints"];
            [queryPoint whereKey:@"username" equalTo: _currentName];
            [queryPoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                int currentPoints = [object[@"points"] intValue];
                lblExperiences.text = [NSString stringWithFormat:@"Experiment: %d", currentPoints];
            }];
            PFFile *userImageFile = currentUser[@"avatar"];
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
        return cell;
    }else if(indexPath.section == 1){
        NSString *CellIdentifier = @"post";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *content = (UITextField *)[cell viewWithTag:200];
        content.borderStyle = UITextBorderStyleRoundedRect;
        content.borderStyle = UITextBorderStyleNone;

        return cell;
    }else if(indexPath.section == 2){
        NSString *CellIdentifier = @"status";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PFObject *status = [_listStatus objectAtIndex:indexPath.row];
        UILabel *time = (UILabel *)[cell viewWithTag:1001];
        UITextView *content = (UITextView *)[cell viewWithTag:1002];
        UIImageView *avatar = (UIImageView *)[cell viewWithTag:1003];
        time.text = status[@"time"];
        content.text = status[@"content"];
        PFFile *userImageFile = currentUser[@"avatar"];
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
        return cell;
    }
    return nil;
}
- (IBAction)postStatusWasPressed:(id)sender {
    
    UITextField *textField = (UITextField *)[_tblTimeline viewWithTag:200];
    
    PFObject *newStatus = [PFObject objectWithClassName:@"Status"];
    [newStatus setObject:_currentName forKey:@"username"];
    [newStatus setObject:textField.text forKey:@"content"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    [newStatus setValue:dateString forKey:@"time"];
    [newStatus saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        textField.text = @"";
        [self viewDidLoad];
    }];
}
@end
