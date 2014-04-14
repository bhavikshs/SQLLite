//
//  ViewController.h
//  UserDetail
//
//  Created by Ravi on 10/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "FMDatabase.h"

@interface ViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPopoverControllerDelegate,UIAlertViewDelegate,userDetailDelegate>
{
    UIImagePickerController *ipc;
    UIPopoverController *popover;
    IBOutlet UIImageView *imgUser;
    IBOutlet UIScrollView *svUser;
    IBOutlet UIButton *btnPhoto, *btnSubmit;
    IBOutlet UITextField *txtUserName, *txtEmail, *txtMobileNumber, *txtPassword, *txtConfirmPassword;
    NSString *strSelectedUserId;
    FMDatabase *db;
    UserModel *user;
    BOOL isUserUpdate;
}

-(void)selectedIdis:(NSString *)strId;
-(void)setBool:(BOOL)isUpdate;

-(IBAction)btnSubmitPressed:(id)sender;
-(IBAction)btnHideKeyboardPresed:(id)sender;
-(IBAction)btnUploadPhotoPresed:(id)sender;

@end
