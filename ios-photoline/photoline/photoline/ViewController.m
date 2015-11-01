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
    mz = [[MZAlubumReader alloc]init];
    [mz fetch:^(NSMutableArray *response) {
        _ordermedia =response;
        [self.table reloadData];
    }];
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
