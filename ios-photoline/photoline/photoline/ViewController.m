//
//  ViewController.m
//  photoline
//
//  Created by Muhammed Salih on 31/10/15.
//  Copyright © 2015 Muhammed Salih T A. All rights reserved.
//

#import "ViewController.h"
#import"ALAsset+ALAsset.h"
#import "MZAlubumReader.h"


@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *ordermedia;
@property(nonatomic,strong)IBOutlet UITableView* table;
@end

@implementation ViewController
MZAlubumReader *mz ;
- (void)viewDidLoad {
    [super viewDidLoad];
//    mz = [[MZAlubumReader alloc]init];
//    [mz fetch:^(NSMutableArray *response) {
//        _ordermedia =response;
//        [self.table reloadData];
//    }];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions =
    @[@"public_profile", @"user_photos", @"email", @"user_friends"];
    loginButton.center = self.view.center;
    [loginButton setDelegate:self];
    [self.view addSubview:loginButton];
    
}

-(BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton{
    return true;
}
-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}
- (void)
loginButton: 	(FBSDKLoginButton *)loginButton
didCompleteWithResult: 	(FBSDKLoginManagerLoginResult *)result
error: 	(NSError *)error{
    NSLog(@"%@",result);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @[@"images",@"link",@"backdated_time"], @"fields",
                                   nil];
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"photos" parameters:@{ @"fields" : @"images,backdated_time,link"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
             }
         }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return [_ordermedia count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(_ordermedia != nil){
        return [[_ordermedia objectAtIndex:section] count];
    }
    return  0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ALAsset *asset =[[_ordermedia objectAtIndex:section]objectAtIndex:0];
    return [NSString stringWithFormat:@"%@",[asset day] ]  ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView* imageView = (UIImageView *)[cell.contentView viewWithTag:1001];
    ALAsset * alAsset = [[_ordermedia objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [mz getImage:alAsset :^(UIImage *image) {
        imageView.image= image;
    }];
    return cell;
}
@end
