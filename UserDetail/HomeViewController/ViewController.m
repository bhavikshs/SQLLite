//
//  ViewController.m
//  UserDetail
//
//  Created by Ravi on 10/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"UserDetails";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    db = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/Documents/UserDetail.sqlite",NSHomeDirectory()]];
    [db open];
    [svUser setContentSize:CGSizeMake(320, 800)];
}

-(void)selectedIdis:(NSString *)strId
{
    strSelectedUserId = strId;
}

-(void)setBool:(BOOL)isUpdate
{
    isUserUpdate = isUpdate;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)fetchUpdateDtails{
    db = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/Documents/UserDetail.sqlite",NSHomeDirectory()]];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"Select * from UserDetail where userId = ?", strSelectedUserId];
    while ([rs next]) {
      user = [[UserModel alloc] init];
         user.strUserName = [rs stringForColumn:@"userName"];
         user.strEmail = [rs stringForColumn:@"email"];
         user.strMobileNumber = [rs stringForColumn:@"mobileNumber"];
         user.strPassword = [rs stringForColumn:@"password"];
         user.strConfirmPassword = [rs stringForColumn:@"confirmPassword"];
    }
   
       txtUserName.text = user.strUserName;
       txtEmail.text = user.strEmail;
       txtMobileNumber.text = user.strMobileNumber;
       txtPassword.text = user.strPassword;
       txtConfirmPassword.text = user.strConfirmPassword;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [svUser setContentSize:CGSizeMake(320, 800)];
    
    if (isUserUpdate) {
        btnPhoto.titleLabel.text = @"Change Photo";
        btnSubmit.titleLabel.text = @"Update";
        [self fetchUpdateDtails];
    }else{
        txtUserName.text = @"";
        txtEmail.text = @"";
        txtMobileNumber.text = @"";
        txtPassword.text = @"";
        txtConfirmPassword.text = @"";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark DelegateMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)invokeAlertWithMsg:(NSString *)strMsg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

#pragma mark ActionMethods

-(IBAction)btnSubmitPressed:(id)sender
{
    if ([txtUserName.text isEqualToString:@""] || [txtEmail.text isEqualToString:@""] || [txtMobileNumber.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""] || [txtConfirmPassword.text isEqualToString:@""]){
        [self invokeAlertWithMsg:@"Please enter Required Data!"];
    }else if(![self IsValidEmail:txtEmail.text Strict:YES]){
          [self invokeAlertWithMsg:@"Please Enter valid email address!"];
    }else if (![txtPassword.text isEqualToString:txtConfirmPassword.text]){
        [self invokeAlertWithMsg:@"Please confirm password!"];
    }else{
        [db open];
        if (isUserUpdate) {
            [db executeUpdate:@"update UserDetail set userName=?,email=?,mobileNumber=?,password=?,confirmPassword=? where userId=?",txtUserName.text,txtEmail.text,txtMobileNumber.text,txtPassword.text,txtConfirmPassword.text,strSelectedUserId];
            isUserUpdate = NO;
            btnPhoto.titleLabel.text = @"Upload Photo";   
            btnSubmit.titleLabel.text = @"Submit";
            [self invokeAlertWithMsg:@"UserDetail updated successfully!"];
            txtUserName.text = @"";
            txtEmail.text = @"";
            txtMobileNumber.text = @"";
            txtPassword.text = @"";
            txtConfirmPassword.text = @"";
        }else{
            [db executeUpdate:@"Insert into UserDetail (userName,email,mobileNumber, password, confirmPassword) values(?, ?, ?, ?, ?)", txtUserName.text, txtEmail.text,txtMobileNumber.text,txtPassword.text,txtConfirmPassword.text, nil];
            
            DetailViewController *dvc = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
            dvc.delegate = self;
            [self.navigationController pushViewController:dvc animated:YES];
        }
    }
}

-(IBAction)btnHideKeyboardPresed:(id)sender
{
    [txtUserName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtMobileNumber resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
}

-(IBAction)btnUploadPhotoPresed:(id)sender
{
    ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentViewController:ipc animated:YES completion:nil];
    } else {
        popover=[[UIPopoverController alloc] initWithContentViewController:ipc];
        [popover presentPopoverFromRect:((UIButton*)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (popover.isPopoverVisible) {
            [popover dismissPopoverAnimated:YES];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        [picker dismissViewControllerAnimated:NO completion:nil];
    } else {
        if (popover.isPopoverVisible) {
            [popover dismissPopoverAnimated:YES];
        }
    }
    imgUser.image = image;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
