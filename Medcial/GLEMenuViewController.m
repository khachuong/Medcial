//
//  GLEMenuViewController.m
//  Medcial
//
//  Created by Khachuong on 6/11/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEMenuViewController.h"
#import <Parse/Parse.h>
#import "GLELoginViewController.h"
#import "SWRevealViewController.h"
#import "GLEHomeViewController.h"
#import "GLEUpdatePersonInfoViewController.h"

@interface GLEMenuViewController ()

@end

@implementation GLEMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    _menuItems = @[@"user", @"updateInfo",@"questions", @"friends",@"setting",@"appInfo",@"logout"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
       [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"appbackground.png"]]];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"appbackground.png"]]];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 78;
    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:100];
    lbl.text = [[PFUser currentUser] username];
    UIImageView *userAvatar = (UIImageView *)[cell viewWithTag:101];
    
    PFUser *currentUser = [PFUser currentUser];
    PFFile *userImageFile = currentUser[@"avatar"];
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
    UILabel *pointsLable = (UILabel *)[cell viewWithTag:102];
    PFQuery *queryPoint = [PFQuery queryWithClassName:@"UserPoints"];
    [queryPoint whereKey:@"username" equalTo:[currentUser username]];
    [queryPoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        int currentPoints = [object[@"points"] intValue];
        pointsLable.text = [NSString stringWithFormat:@"Experiment: %d", currentPoints];
    }];
    
    [cell setOpaque:FALSE];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showUpdate"]){
        [[self presentedViewController] dismissViewControllerAnimated:NO completion:nil];
    }else if([segue.identifier isEqualToString:@"showFriends"]){
        [[self presentedViewController] dismissViewControllerAnimated:NO completion:nil];
    }else if([segue.identifier isEqualToString:@"showQuestions"]){
        [[self presentedViewController] dismissViewControllerAnimated:NO completion:nil];
    }else if([segue.identifier isEqualToString:@"showAppInfo"]){
        [[self presentedViewController] dismissViewControllerAnimated:NO completion:nil];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    if([CellIdentifier isEqualToString:@"logout"]){
        [PFUser logOut];
        
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GLELoginViewController *loginViewController = [loginStoryboard instantiateInitialViewController];
        loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[self presentedViewController] dismissViewControllerAnimated:NO completion:nil];
        
        [self presentViewController:loginViewController animated:NO completion:nil];
        
    }
}

@end
