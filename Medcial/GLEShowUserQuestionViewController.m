//
//  GLEShowUserQuestionViewController.m
//  Medcial
//
//  Created by Khachuong on 6/24/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEShowUserQuestionViewController.h"
#import "GLEUpdateAnswerViewController.h"
#import "GLEUpdateQuestionViewController.h"
#import "GLEViewFriendProfileViewController.h"
#import "IQKeyboardManager.h"
#import "GLEAnimator.h"
#import "YFInputBar.h"
#import <Parse/Parse.h>
@interface GLEShowUserQuestionViewController ()<YFInputBarDelegate>

@end

@implementation GLEShowUserQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];

    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *answers = [PFQuery queryWithClassName:@"Answer"];
        [answers whereKey:@"questionID" equalTo:_questionID];
        [answers orderByDescending:@"isAcceptable"];
        [answers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _listAnswers = objects;
            [_tbList reloadData];
            
        }];
        _listAllItems = [NSMutableArray arrayWithArray:_listAnswers];
        PFQuery *questions = [PFQuery queryWithClassName:@"Question"];
        [questions whereKey:@"objectId" equalTo:_questionID];
        [questions getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            _currentQuestion = object;
        }];
    });
    
    _cellItems = @[@"question", @"comments"];
    IQKeyboardManager *iq = [IQKeyboardManager sharedManager];
    iq.enable = NO;
    iq.enableAutoToolbar = NO;
    _inputBar = [[YFInputBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds)-44, 320, 44)];
    
    _inputBar.backgroundColor = [UIColor colorWithRed:79.0/255.0 green:219.0/255.0 blue:73.0/255.0 alpha:1.0f];
    
    _inputBar.delegate = self;
    _inputBar.clearInputWhenSend = YES;
    _inputBar.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:_inputBar];
    self.navigationItem.title = @"Question";
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return 366;
    }else if(indexPath.section == 1)
    {
        return 165;
    }
    return 0;
    
}
-(void)viewDidLayoutSubviews{
    [self viewDidLoad];
    [self.view setNeedsDisplay];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _inputBar.hidden = NO;
    [_inputBar becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Question";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return [_listAnswers count];
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
        return @"Answers";
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
        
        NSString *CellIdentifier = [_cellItems objectAtIndex:0];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        UIButton *followButton = (UIButton *)[cell viewWithTag:110];
        
        UITextView *description = (UITextView *)[cell viewWithTag:106];
        UIImageView *avatar = (UIImageView *)[cell viewWithTag:102];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PFQuery *queryFollow = [PFQuery queryWithClassName:@"FollowQuestion"];
            [queryFollow whereKey:@"questionID" equalTo:_questionID];
            [queryFollow whereKey:@"username" equalTo:[[PFUser currentUser] username]];
            [queryFollow getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if(error)
                {
                    [followButton setImage:[UIImage imageNamed:@"quan-tam.png"] forState:UIControlStateNormal];
                }else{
                    [followButton setImage:[UIImage imageNamed:@"dang-quan-tam.png"] forState:UIControlStateNormal];
                }
            }];
            
            
            PFQuery *questions = [PFQuery queryWithClassName:@"Question"];
            [questions whereKey:@"objectId" equalTo:_questionID];
            [questions getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {

                _questioner = object[@"username"];
                UILabel *username = (UILabel *)[cell viewWithTag:103];
                UILabel *pointLabel = (UILabel *)[cell viewWithTag:109];
                UILabel *time = (UILabel *)[cell viewWithTag:101];
                time.text = object[@"time"];
                
                
                UILabel *title = (UILabel *)[cell viewWithTag:105];
                title.text = object[@"title"];
                
                bool check = [object[@"isHideName"] boolValue];
                if(check){
                    
                    username.text = @"Anonymous";
                    avatar.image = [UIImage imageNamed:@"icn_noimage.png"];
                    pointLabel.text = @"";
                }
                else{
                    
                    username.text = object[@"username"];
                    PFQuery *user = [PFUser query];
                    [user whereKey:@"username" equalTo:object[@"username"]];
                    [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        PFUser *gotUser = (PFUser *)object;
                        PFFile *userImageFile = gotUser[@"avatar"];
                        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                            UIImage *image = [UIImage imageWithData:imageData];
                            avatar.image = image;
                            avatar.layer.borderWidth = 3.0f;
                            
                            avatar.layer.borderColor = [UIColor whiteColor].CGColor;
                            
                            avatar.layer.cornerRadius = avatar.frame.size.height /2;
                            avatar.layer.masksToBounds = YES;
                            avatar.layer.borderWidth = 0;
                        }];
                    }];
                    PFQuery *queryPoint = [PFQuery queryWithClassName:@"UserPoints"];
                    [queryPoint whereKey:@"username" equalTo:object[@"username"]];
                    [queryPoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        int currentPoints = [object[@"points"] intValue];
                        pointLabel.text = [NSString stringWithFormat:@"Experiment: %d", currentPoints];
                    }];
                    
                }
                description.text = object[@"content"];
                 description.textAlignment = NSTextAlignmentJustified;
                description.editable = NO;
                description.selectable = NO;
                PFFile *diseaseImage = object[@"image"];
                [diseaseImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    _imageView.image = [UIImage imageNamed:@"default_question.jpg"];
                }];
            }];
        });
        UIButton *editButton = (UIButton *)[cell viewWithTag:108];
        UIButton *deleteButton = (UIButton *)[cell viewWithTag:107];
        NSString *currentName = [[PFUser currentUser]username ];
        if([_questioner isEqualToString:currentName]){
            editButton.hidden = NO;
            deleteButton.hidden = NO;
        }
        else{
            editButton.hidden = YES;
            deleteButton.hidden = YES;
        }
        
        UILabel *numberOfVotes = (UILabel *)[cell viewWithTag:104];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PFQuery *votes = [PFQuery queryWithClassName:@"VoteQuestion"];
            [votes whereKey:@"questionID" equalTo:_questionID];
            [votes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                numberOfVotes.text = [NSString stringWithFormat:@"%tu", [objects count]];
            }];
        });
        UILabel *numberOfDisVotes = (UILabel *)[cell viewWithTag:111];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PFQuery *votes = [PFQuery queryWithClassName:@"DisVoteQuestion"];
            [votes whereKey:@"questionID" equalTo:_questionID];
            [votes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                numberOfDisVotes.text = [NSString stringWithFormat:@"%tu", [objects count]];
            }];
        });
        
        return cell;
        
    }else if(indexPath.section == 1){
        NSString *CellIdentifier = [_cellItems objectAtIndex:1];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        PFObject *answerer = [_listAnswers objectAtIndex:indexPath.row];
        
        UILabel *userName = (UILabel *)[cell viewWithTag:200];
        UITextView *answer = (UITextView *)[cell viewWithTag:202];
        answer.text = answerer[@"content"];
        answer.editable = NO;
        answer.selectable = NO;
        
        UIImageView *commenterAvatar = (UIImageView *)[cell viewWithTag:201];
        UILabel *poinstLable = (UILabel *)[cell viewWithTag:206];
        UILabel *doctorInfo = (UILabel *)[cell viewWithTag:207];
        UIImageView *doctorIcon = (UIImageView *)[cell viewWithTag:208];
        doctorInfo.hidden = YES;
        doctorIcon.hidden = YES;
        
        bool check = [_currentQuestion[@"isHideName"] boolValue];
        if([answerer[@"username"] isEqualToString:_questioner] && check == YES){
            userName.text = @"Anonymous";
            commenterAvatar.image = [UIImage imageNamed:@"icn_noimage.png"];
            poinstLable.text = @"";
        }else{
            userName.text = answerer[@"username"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                PFQuery *queryPoint = [PFQuery queryWithClassName:@"UserPoints"];
                [queryPoint whereKey:@"username" equalTo:answerer[@"username"]];
                [queryPoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    int currentPoints = [object[@"points"] intValue];
                    poinstLable.text = [NSString stringWithFormat:@"Experiment: %d", currentPoints];
                }];
                
                PFQuery *user = [PFUser query];
                [user whereKey:@"username" equalTo:answerer[@"username"]];
                [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    
                    if(!error){
                        PFUser *gotCommenter = (PFUser *)object;
                        bool checkIsDoctor = [gotCommenter[@"isDoctor"] boolValue];
                        if(checkIsDoctor == YES){
                            doctorIcon.hidden = NO;
                            
                            PFQuery *queryQualifi = [PFQuery queryWithClassName:@"Qualification"];
                            [queryQualifi getObjectInBackgroundWithId:gotCommenter[@"qualification"] block:^(PFObject *object, NSError *error) {
                                NSString *qualification = object[@"qualificationName"];
                                PFQuery *queryDepartment = [PFQuery queryWithClassName:@"Department"];
                                [queryDepartment getObjectInBackgroundWithId:gotCommenter[@"department"] block:^(PFObject *object, NSError *error) {
                                    NSString *department = object[@"departmentName"];
                                    doctorInfo.hidden = NO;
                                    doctorInfo.text = [NSString stringWithFormat:@"%@ - %@", qualification, department];
                                    userName.textColor = [UIColor colorWithRed:127.0/255.0 green:170.0/255.0 blue:62.0/255.0 alpha:1.0f];
                                }];
                            } ];
                        }else{
                            
                            userName.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0f];
                        }
                        PFFile *userImageFile = gotCommenter[@"avatar"];
                        if(userImageFile == nil){
                            commenterAvatar.image = [UIImage imageNamed:@"icn_noimage.png"];
                        }
                        else{
                            [userImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                UIImage *image = [UIImage imageWithData:data];
                                commenterAvatar.image = image;
                                commenterAvatar.layer.borderWidth = 3.0f;
                                
                                commenterAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
                                
                                commenterAvatar.layer.cornerRadius = commenterAvatar.frame.size.height /2;
                                commenterAvatar.layer.masksToBounds = YES;
                                commenterAvatar.layer.borderWidth = 0;
                            }];
                        }
                    }else{
                        commenterAvatar.image = [UIImage imageNamed:@"icn_noimage.png"];
                    }
                }];
                
            });
        }
        UIImageView *bestAnswer = (UIImageView *)[cell viewWithTag:210];
        bestAnswer.hidden = YES;
        bool checkBestAnswer = [answerer[@"isAcceptable"] boolValue];
        if(checkBestAnswer == YES)
        {
            bestAnswer.hidden = NO;
        }
        UILabel *numberOfVotes = (UILabel *)[cell viewWithTag:203];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PFQuery *votes = [PFQuery queryWithClassName:@"VoteAnswer"];
            [votes whereKey:@"answerID" equalTo:answerer.objectId];
            [votes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                numberOfVotes.text = [NSString stringWithFormat:@"%tu", [objects count]];
            }];
            
        });
        UILabel *numberOfDisVotes = (UILabel *)[cell viewWithTag:209];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PFQuery *votes = [PFQuery queryWithClassName:@"DisVoteAnswer"];
            [votes whereKey:@"answerID" equalTo:answerer.objectId];
            [votes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                numberOfDisVotes.text = [NSString stringWithFormat:@"%tu", [objects count]];
            }];
        });
        
        return cell;
    }
    return nil;
}

-(void)inputBar:(YFInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)content
{
    if([content length] != 0){
        PFObject *answer = [PFObject objectWithClassName:@"Answer"];
        [answer setObject:[[PFUser currentUser] username] forKey:@"username"];
        [answer setObject:_questionID forKey:@"questionID"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        [answer setObject:dateString forKey:@"time"];
        [answer setObject:content forKey:@"content"];
        [answer setObject:@NO forKey:@"isAcceptable"];
        [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self viewDidLoad];
        }];}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_inputBar resignFirstResponder];
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)voteQuestionWasPressed:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"VoteQuestion"];
        NSString *currentUser = [[PFUser currentUser] username];
        [query whereKey:@"questionID" equalTo:_questionID];
        [query whereKey:@"username" equalTo:currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error)
            {
                if([objects count] == 0){
                    
                    PFQuery *checkDisVote = [PFQuery queryWithClassName:@"DisVoteQuestion"];
                    [checkDisVote whereKey:@"questionID" equalTo:_questionID];
                    [checkDisVote whereKey:@"username" equalTo:currentUser];
                    [checkDisVote findObjectsInBackgroundWithBlock:^(NSArray *disObjects, NSError *error) {
                        if([disObjects count] == 0){
                            PFObject *obj = [PFObject objectWithClassName:@"VoteQuestion"];
                            [obj setObject:[[PFUser currentUser] username] forKey:@"username"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
                            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
                            NSString *dateString = [formatter stringFromDate:[NSDate date]];
                            [obj setValue:dateString forKey:@"time"];
                            [obj setObject:_questionID forKey:@"questionID"];
                            
                            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                            NSString *strApplicationUUID = [oNSUUID UUIDString];
                            [obj setObject:strApplicationUUID forKey:@"identifier"];
                            PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
                            [updatePoint whereKey:@"username" equalTo:_questioner];
                            [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                int oldPoints = [object[@"points"] intValue];
                                [object setObject:[NSNumber numberWithInt:oldPoints+1] forKey:@"points"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                }];
                            }];
                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_tbList reloadData];
                                [self viewDidLoad];
                            }];
                        }else{
                            PFObject *disVote = [disObjects objectAtIndex:0];
                            [disVote deleteEventually];
                            PFObject *obj = [PFObject objectWithClassName:@"VoteQuestion"];
                            [obj setObject:[[PFUser currentUser] username] forKey:@"username"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
                            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
                            NSString *dateString = [formatter stringFromDate:[NSDate date]];
                            [obj setValue:dateString forKey:@"time"];
                            [obj setObject:_questionID forKey:@"questionID"];
                            
                            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                            NSString *strApplicationUUID = [oNSUUID UUIDString];
                            [obj setObject:strApplicationUUID forKey:@"identifier"];
                            PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
                            [updatePoint whereKey:@"username" equalTo:_questioner];
                            [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                int oldPoints = [object[@"points"] intValue];
                                [object setObject:[NSNumber numberWithInt:oldPoints+1] forKey:@"points"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                }];
                            }];
                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_tbList reloadData];
                                [self viewDidLoad];
                            }];
                            
                        }
                    }];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn chỉ được bình chọn 1 lần duy nhất trên 1 câu hỏi!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
        }];
    });
    
}

- (IBAction)disVoteQuestionWasPressed:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"DisVoteQuestion"];
        NSString *currentUser = [[PFUser currentUser] username];
        [query whereKey:@"questionID" equalTo:_questionID];
        [query whereKey:@"username" equalTo:currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error)
            {
                if([objects count] == 0){
                    PFQuery *checkDisVote = [PFQuery queryWithClassName:@"VoteQuestion"];
                    [checkDisVote whereKey:@"questionID" equalTo:_questionID];
                    [checkDisVote whereKey:@"username" equalTo:currentUser];
                    [checkDisVote findObjectsInBackgroundWithBlock:^(NSArray *disObjects, NSError *error) {
                        if([disObjects count] == 0){
                            PFObject *obj = [PFObject objectWithClassName:@"DisVoteQuestion"];
                            [obj setObject:[[PFUser currentUser] username] forKey:@"username"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
                            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
                            NSString *dateString = [formatter stringFromDate:[NSDate date]];
                            [obj setValue:dateString forKey:@"time"];
                            [obj setObject:_questionID forKey:@"questionID"];
                            
                            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                            NSString *strApplicationUUID = [oNSUUID UUIDString];
                            [obj setObject:strApplicationUUID forKey:@"identifier"];
                            PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
                            [updatePoint whereKey:@"username" equalTo:_questioner];
                            [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                int oldPoints = [object[@"points"] intValue];
                                [object setObject:[NSNumber numberWithInt:oldPoints-1] forKey:@"points"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                }];
                            }];
                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_tbList reloadData];
                                [self viewDidLoad];
                            }];
                        }else{
                            PFObject *disVote = [disObjects objectAtIndex:0];
                            [disVote deleteEventually];
                            PFObject *obj = [PFObject objectWithClassName:@"DisVoteQuestion"];
                            [obj setObject:[[PFUser currentUser] username] forKey:@"username"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
                            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
                            NSString *dateString = [formatter stringFromDate:[NSDate date]];
                            [obj setValue:dateString forKey:@"time"];
                            [obj setObject:_questionID forKey:@"questionID"];
                            
                            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                            NSString *strApplicationUUID = [oNSUUID UUIDString];
                            [obj setObject:strApplicationUUID forKey:@"identifier"];
                            PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
                            [updatePoint whereKey:@"username" equalTo:_questioner];
                            [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                int oldPoints = [object[@"points"] intValue];
                                [object setObject:[NSNumber numberWithInt:oldPoints-1] forKey:@"points"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                }];
                            }];
                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_tbList reloadData];
                                [self viewDidLoad];
                            }];
                            
                        }
                    }];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn chỉ được bình chọn 1 lần duy nhất trên 1 câu hỏi!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
        }];
    });
    
}

- (IBAction)disVoteAnswerWasPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tbList];
    NSIndexPath *indexPath = [self.tbList indexPathForRowAtPoint:buttonFrame.origin];
    PFObject *answerer = [_listAnswers objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"DisVoteAnswer"];
        NSString *currentUser = [[PFUser currentUser] username];
        [query whereKey:@"questionID" equalTo:_questionID];
        [query whereKey:@"answerID" equalTo:answerer.objectId];
        [query whereKey:@"username" equalTo:currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error)
            {
                if([objects count] == 0){
                    
                    PFQuery *checkVoteAnswer = [PFQuery queryWithClassName:@"VoteAnswer"];
                    [checkVoteAnswer whereKey:@"questionID" equalTo:_questionID];
                    [checkVoteAnswer whereKey:@"username" equalTo:currentUser];
                    [checkVoteAnswer findObjectsInBackgroundWithBlock:^(NSArray *disObjects, NSError *error) {
                        if([disObjects count] == 0){
                            PFObject *obj = [PFObject objectWithClassName:@"DisVoteAnswer"];
                            [obj setObject:[[PFUser currentUser] username] forKey:@"username"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
                            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
                            NSString *dateString = [formatter stringFromDate:[NSDate date]];
                            [obj setValue:dateString forKey:@"time"];
                            [obj setObject:_questionID forKey:@"questionID"];
                            [obj setObject:answerer.objectId    forKey:@"answerID"];
                            
                            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                            NSString *strApplicationUUID = [oNSUUID UUIDString];
                            [obj setObject:strApplicationUUID forKey:@"identifier"];
                            PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
                            [updatePoint whereKey:@"username" equalTo:answerer[@"username"]];
                            [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                int oldPoints = [object[@"points"] intValue];
                                [object setObject:[NSNumber numberWithInt:oldPoints-1] forKey:@"points"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                }];
                            }];                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_tbList reloadData];
                                [self viewDidLoad];
                            }];
                        }else{
                            PFObject *obje = [disObjects objectAtIndex:0];
                            [obje deleteEventually];
                            PFObject *obj = [PFObject objectWithClassName:@"DisVoteAnswer"];
                            [obj setObject:[[PFUser currentUser] username] forKey:@"username"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
                            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
                            NSString *dateString = [formatter stringFromDate:[NSDate date]];
                            [obj setValue:dateString forKey:@"time"];
                            [obj setObject:_questionID forKey:@"questionID"];
                            [obj setObject:answerer.objectId    forKey:@"answerID"];
                            
                            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                            NSString *strApplicationUUID = [oNSUUID UUIDString];
                            [obj setObject:strApplicationUUID forKey:@"identifier"];
                            PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
                            [updatePoint whereKey:@"username" equalTo:answerer[@"username"]];
                            [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                int oldPoints = [object[@"points"] intValue];
                                [object setObject:[NSNumber numberWithInt:oldPoints-1] forKey:@"points"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                }];
                            }];                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_tbList reloadData];
                                [self viewDidLoad];
                            }];
                        }
                    }];
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn chỉ được bình chọn 1 lần duy nhất trên 1 câu trả lời !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
        }];
    });
}
- (IBAction)voteAnswerWasPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tbList];
    NSIndexPath *indexPath = [self.tbList indexPathForRowAtPoint:buttonFrame.origin];
    PFObject *answerer = [_listAnswers objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"VoteAnswer"];
        NSString *currentUser = [[PFUser currentUser] username];
        [query whereKey:@"questionID" equalTo:_questionID];
        [query whereKey:@"answerID" equalTo:answerer.objectId];
        [query whereKey:@"username" equalTo:currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error)
            {
                if([objects count] == 0){
                    PFQuery *checkDisVote = [PFQuery queryWithClassName:@"DisVoteAnswer"];
                    [checkDisVote whereKey:@"questionID" equalTo:_questionID];
                    [checkDisVote whereKey:@"username" equalTo:currentUser];
                    [checkDisVote findObjectsInBackgroundWithBlock:^(NSArray *disObjects, NSError *error){
                        if([disObjects count] == 0){
                            PFObject *obj = [PFObject objectWithClassName:@"VoteAnswer"];
                            [obj setObject:[[PFUser currentUser] username] forKey:@"username"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
                            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
                            NSString *dateString = [formatter stringFromDate:[NSDate date]];
                            [obj setValue:dateString forKey:@"time"];
                            [obj setObject:_questionID forKey:@"questionID"];
                            [obj setObject:answerer.objectId    forKey:@"answerID"];
                            
                            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                            NSString *strApplicationUUID = [oNSUUID UUIDString];
                            [obj setObject:strApplicationUUID forKey:@"identifier"];
                            PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
                            [updatePoint whereKey:@"username" equalTo:answerer[@"username"]];
                            [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                int oldPoints = [object[@"points"] intValue];
                                [object setObject:[NSNumber numberWithInt:oldPoints+2] forKey:@"points"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                }];
                            }];                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_tbList reloadData];
                                [self viewDidLoad];
                            }];
                        }else{
                            PFObject *obje = [disObjects objectAtIndex:0];
                            [obje deleteEventually];
                            
                            PFObject *obj = [PFObject objectWithClassName:@"VoteAnswer"];
                            [obj setObject:[[PFUser currentUser] username] forKey:@"username"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
                            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
                            NSString *dateString = [formatter stringFromDate:[NSDate date]];
                            [obj setValue:dateString forKey:@"time"];
                            [obj setObject:_questionID forKey:@"questionID"];
                            [obj setObject:answerer.objectId    forKey:@"answerID"];
                            
                            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                            NSString *strApplicationUUID = [oNSUUID UUIDString];
                            [obj setObject:strApplicationUUID forKey:@"identifier"];
                            PFQuery *updatePoint = [PFQuery queryWithClassName:@"UserPoints"];
                            [updatePoint whereKey:@"username" equalTo:answerer[@"username"]];
                            [updatePoint getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                int oldPoints = [object[@"points"] intValue];
                                [object setObject:[NSNumber numberWithInt:oldPoints+2] forKey:@"points"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                }];
                            }];                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_tbList reloadData];
                                [self viewDidLoad];
                            }];
                        }
                    }];
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn chỉ được bình chọn 1 lần duy nhất trên 1 câu trả lời !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
        }];
    });
}
- (IBAction)deleteQuestionWasPressed:(id)sender {
    UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you really want to delete this question?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, go ahead!", nil];
    alerts.tag = 2;
    
    [alerts show];
}

- (IBAction)followWasPressed:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"FollowQuestion"];
    [query whereKey:@"questionID" equalTo:_questionID];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(error)
        {
            PFObject *follow = [PFObject objectWithClassName:@"FollowQuestion"];
            follow[@"questionID"] = _questionID;
            follow[@"username"] = [[PFUser currentUser] username];
            [follow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self viewDidLoad];
            }];
        }else{
            [object deleteEventually];
            [self viewDidLoad];
        }
    }];
}
- (IBAction)refreshWasPressed:(id)sender {
    [self viewDidLoad];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex != 0)
        {
            PFObject *object = [PFObject objectWithoutDataWithClassName:@"Answer"
                                                               objectId:_currentAnswerID];
            [object deleteEventually];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Delete your answer successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self viewDidLoad];
            [self.view setNeedsDisplay];
        }
    }
    if (alertView.tag == 2){
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"Question"
                                                           objectId:_questionID];
        [object deleteEventually];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Delete your question successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (popup == _userPopup) {
        switch (popup.tag) {
            case 1: {
                switch (buttonIndex) {
                    case 0:
                        [self viewProfile];
                        break;
                    case 1:
                        [self reportBadAnswer];
                        break;
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
        
    }
    else if (popup == _fullUserPopup) {
        switch (popup.tag) {
            case 1: {
                switch (buttonIndex) {
                    case 0:
                        [self viewProfile];
                        // view profile
                        break;
                    case 1:
                        [self bestAnswer];
                        break;
                    case 2:
                        [self reportBadAnswer];
                        break;
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
        
    }
    
}
- (void) viewProfile{
    bool check = [_currentQuestion[@"isHideName"] boolValue];
    if([_chosenUsername  isEqualToString:_currentQuestion[@"username"]] && check == YES){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You cannot see information of anonymous person!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        GLEViewFriendProfileViewController *viewController =
        [storyboard instantiateViewControllerWithIdentifier:@"GLEViewFriendProfileViewController"];
        viewController.username = _chosenUsername;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void) bestAnswer{
    PFQuery *updateQuery = [PFQuery queryWithClassName:@"Answer"];
    [updateQuery whereKey:@"questionID" equalTo:_questionID];
    [updateQuery whereKey:@"isAcceptable" equalTo:@YES];
    [updateQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count] == 0){
            PFQuery *query = [PFQuery queryWithClassName:@"Answer"];
            [query getObjectInBackgroundWithId:_currentID block:^(PFObject *object, NSError *error) {
                object[@"isAcceptable"] = @YES;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Cảm ơn bạn đã bình chọn câu trả lời hay nhất, phù hợp nhất với câu hỏi của bạn!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }];
            }];
        }else if([objects count] == 1){
            PFObject *obj = [objects objectAtIndex:0];
            obj[@"isAcceptable"] = @NO;
            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                PFQuery *query = [PFQuery queryWithClassName:@"Answer"];
                [query getObjectInBackgroundWithId:_currentID block:^(PFObject *object, NSError *error) {
                    object[@"isAcceptable"] = @YES;
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Cảm ơn bạn đã bình chọn câu trả lời hay nhất, phù hợp nhất với câu hỏi của bạn!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }];
                }];
            }];
            
        }
    }];
}
-(void) reportBadAnswer{
    NSString *currentName = [[PFUser currentUser]username];
    PFQuery *query = [PFQuery queryWithClassName:@"ReportBadAnswer"];
    [query whereKey:@"username" equalTo:currentName];
    [query whereKey:@"answerID" equalTo:_currentID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count] == 0){
            PFObject *obj = [PFObject objectWithClassName:@"ReportBadAnswer"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm dd-MM-yyyy"];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"vi-vn"]];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            [obj setObject:currentName forKey:@"username"];
            [obj setObject:dateString forKey:@"time"];
            [obj setObject:_currentID forKey:@"answerID"];
            [obj setObject:_questionID forKey:@"questionID"];
            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Báo cáo thành công" message:@"Cảm ơn bạn đã báo cáo vi phạm cho chúng tôi!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn đã báo cáo câu trả lời này vi phạm rồi. Xin cảm ơn!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_inputBar resignFirstResponder];
    if(indexPath.section == 0){
        
    }
    if(indexPath.section ==1){
        PFObject *answerer = [_listAnswers objectAtIndex:indexPath.row];
        NSString *currentName = [[PFUser currentUser]username];
        if(![answerer[@"username"] isEqualToString:currentName]){
            if([currentName isEqualToString:_questioner]){
                _fullUserPopup = [[UIActionSheet alloc] initWithTitle:@"Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View profile",
                                  @"Best answer for my question",
                                  @"Report to system",
                                  nil];
                _fullUserPopup.tag = 1;
                [_fullUserPopup showInView:[UIApplication sharedApplication].keyWindow];
                _chosenUsername = answerer[@"username"];
                _currentID = answerer.objectId;
            }else{
                _chosenUsername = answerer[@"username"];
                _userPopup = [[UIActionSheet alloc] initWithTitle:@"Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View profile",
                              @"Report to system",
                              nil];
                _userPopup.tag = 1;
                [_userPopup showInView:[UIApplication sharedApplication].keyWindow];
                _currentID = answerer.objectId;
            }
            
        }
    }
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    GLEAnimator *animator = [[GLEAnimator alloc] init];
    animator.presenting = YES;
    return animator;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    GLEAnimator *animator = [GLEAnimator new];
    return animator;
}

@end
