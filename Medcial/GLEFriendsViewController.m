//
//  GLEFriendsViewController.m
//  Medcial
//
//  Created by Khachuong on 7/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEFriendsViewController.h"
#import "GLEViewFriendProfileViewController.h"

@interface GLEFriendsViewController ()

@end

@implementation GLEFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *currentUser = [[PFUser currentUser] username];
        PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
        [query whereKey:@"friendName" equalTo:currentUser];
        [query orderByAscending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listFriends = objects;
            [_tblFriends reloadData];
        }];
    });
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"Friends list"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [myLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setText:@"Friends list"];
    [self.navigationController.navigationBar.topItem setTitleView:myLabel];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listFriends count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"friendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *obj = [_listFriends objectAtIndex:indexPath.row];
    UIImageView *userAvatar = (UIImageView *)[cell viewWithTag:100];
    UILabel *username = (UILabel *)[cell viewWithTag:101];
    UILabel *experience = (UILabel *)[cell viewWithTag: 102];
    UIButton *unFriend = (UIButton *)[cell viewWithTag:103];
    UIButton *acceptFriend = (UIButton *)[cell viewWithTag:104];
    unFriend.hidden = YES;
    acceptFriend.hidden = YES;
    username.text = obj[@"username"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        bool check = [obj[@"isFriend"] boolValue];
        if(check){
            
            unFriend.hidden = NO;
        }else{
            
            acceptFriend.hidden = NO;
        }
    });
    
    PFQuery *queryPoint = [PFQuery queryWithClassName:@"UserPoints"];
    [queryPoint whereKey:@"username" equalTo: obj[@"username"]];
    [queryPoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        int currentPoints = [object[@"points"] intValue];
        experience.text = [NSString stringWithFormat:@"Experiment: %d", currentPoints];
    }];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:obj[@"username"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFFile *userImageFile = object[@"avatar"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                userAvatar.image = image;
                userAvatar.layer.borderWidth = 3.0f;
                
                userAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
                
                userAvatar.layer.cornerRadius = userAvatar.frame.size.height /2;
                userAvatar.layer.masksToBounds = YES;
                userAvatar.layer.borderWidth = 0;
                
            }
        }];
    }];
    return cell;
}

- (IBAction)backWasPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)acceptFriendWasPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tblFriends];
     NSIndexPath *indexPath = [self.tblFriends indexPathForRowAtPoint:buttonFrame.origin];
    PFObject *obj = [_listFriends objectAtIndex:indexPath.row];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"friendName" equalTo:obj[@"friendName"]];
    [query whereKey:@"username" equalTo:obj[@"username"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"isFriend"] = @YES;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            PFQuery *queryFriend = [PFQuery queryWithClassName:@"Friends"];
            [queryFriend whereKey:@"friendName" equalTo:obj[@"username"]];
            [queryFriend whereKey:@"username" equalTo:obj[@"friendName"]];
            [queryFriend getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
                if(obj !=nil){
                    obj[@"isFriend"] = @YES;
                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [_tblFriends reloadData];
                        [self viewDidLoad];
                    }];
                }else{
                    [_tblFriends reloadData];
                    [self viewDidLoad];
                }
            }];
            
            
        }];
    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath =  [_tblFriends indexPathForSelectedRow];
    PFObject *obj = [_listFriends objectAtIndex:indexPath.row];
    if([segue.identifier isEqualToString:@"showFriendsProfile"]){
        GLEViewFriendProfileViewController *viewController = (GLEViewFriendProfileViewController *)segue.destinationViewController;
        viewController.username = obj[@"username"];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *obj = [_listFriends objectAtIndex:indexPath.row];
    [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Xóa kết bạn thành công!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self viewDidLoad];
        [_tblFriends reloadData];
    }];
}
- (IBAction)cancelWasPressed:(id)sender {
}
@end
