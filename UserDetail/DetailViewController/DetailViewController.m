//
//  DetailViewController.m
//  UserDetail
//
//  Created by Ravi on 10/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController
@synthesize tblUserDetail, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Details";
    }
    return self;
}

-(void)fetchData
{
    db = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/Documents/UserDetail.sqlite",NSHomeDirectory()]];
    [db open];
    marrUserDetails = [[NSMutableArray alloc] init];
    FMResultSet *rs = [db executeQuery:@"Select * from UserDetail"];
    while ([rs next]) {
        user = [[UserModel alloc] init];
        user.strUserId = [rs stringForColumn:@"userId"];
        user.strUserName = [rs stringForColumn:@"userName"];
        user.strEmail = [rs stringForColumn:@"email"];
        user.strMobileNumber = [rs stringForColumn:@"mobileNumber"];
        [marrUserDetails addObject:user];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return marrUserDetails.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell  = (UserCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        NSArray *arr;
        arr=[[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
        for (id idCell in arr)
        {
            if([idCell isKindOfClass:[UITableViewCell class]])
            {
                cell=(UserCell *) idCell;
                break;
            }
        }
        UIView *goldenColor = [[UIView alloc] init];
        goldenColor.backgroundColor = [UIColor colorWithRed:123.0/255.0 green:101.0/255.0 blue:77.0/255.0 alpha:1.0];
        cell.selectedBackgroundView = goldenColor;
        user = [marrUserDetails objectAtIndex:indexPath.row];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.lblOne.text = user.strUserName;
        cell.lblTwo.text = user.strEmail;
        cell.lblThree.text = user.strMobileNumber;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexpath
{
    user = [marrUserDetails objectAtIndex:indexpath.row];
    [self.delegate selectedIdis:user.strUserId];
    [self.delegate setBool:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [db open];
            user = [marrUserDetails objectAtIndex:indexPath.row];
            [db executeUpdate:@"Delete from UserDetail where userId = ?", user.strUserId];
            [marrUserDetails removeObjectAtIndex:indexPath.row];
            [tblUserDetail deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
        [self setEditing:NO animated:YES];
        [tblUserDetail reloadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: animated];
    [self.tblUserDetail setEditing:editing animated:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self fetchData];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [tblUserDetail reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
