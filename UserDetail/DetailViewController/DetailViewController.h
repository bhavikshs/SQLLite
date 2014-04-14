//
//  DetailViewController.h
//  UserDetail
//
//  Created by Ravi on 10/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "UserCell.h"
#import "UserModel.h"

@protocol userDetailDelegate <NSObject>

-(void)selectedIdis:(NSString *)strId;
-(void)setBool:(BOOL)isUpdate;

@end

@interface DetailViewController : UIViewController
{
    FMDatabase *db;
    UserModel *user;
    NSMutableArray *marrUserDetails;
    NSString *strUserName, *strEmail, *strMobileNumber;
}

@property (nonatomic, assign) id <userDetailDelegate> delegate;
@property (nonatomic,retain) IBOutlet UITableView *tblUserDetail;
@end
