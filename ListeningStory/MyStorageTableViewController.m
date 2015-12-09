//
//  MyStorageTableViewController.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/26.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "MyStorageTableViewController.h"
#import "HomePageViewController.h"
#import "SummaryTableViewCell.h"

#import "DBManager.h"
#import "FMDatabase.h"
#import "BaseModel.h"
#import "SummaryModel.h"
@interface MyStorageTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *myStorageTableView;
@end

@implementation MyStorageTableViewController
static NSString *idStr =@"SummaryCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myStorageTableView =self.tableView;
    self.view.backgroundColor =[UIColor colorWithRed:0.951 green:0.935 blue:0.812 alpha:1.000];
    //    _myStorageTableView.backgroundColor =[UIColor colorWithRed:0.951 green:0.935 blue:0.812 alpha:1.000];
    _myStorageTableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];;
    [_myStorageTableView registerNib:[UINib nibWithNibName:@"SummaryTableViewCell" bundle:nil]  forCellReuseIdentifier:idStr];
    self.navigationItem.title =@"我的收藏";
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(10, 20, 50, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonbar_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr forIndexPath:indexPath ];
    
    SummaryModel *summaryModel = [[SummaryModel alloc]init];
    summaryModel =_dataList[indexPath.row];
    cell.model =summaryModel;
    cell.backgroundColor =[UIColor colorWithRed:0.951 green:0.935 blue:0.812 alpha:1.000];
    cell.selectionStyle =UITableViewCellSelectionStyleBlue;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
//
//    HomePageViewController *homePageViewController =[[HomePageViewController alloc]init];
//    SummaryModel *summaryModel = [[SummaryModel alloc]init];
//    summaryModel =_dataList[indexPath.row];
//    homePageViewController.currentIndex =6;
//    NSLog(@"homePageViewController.currentIndex：%ld",(long)homePageViewController.currentIndex);
////    [self presentViewController:self.navigationController.presentingViewController animated:YES completion:nil];
////    [self pushViewController:homePageViewController animated:YES];
//    NSLog(@"当前选中的是：%ld",(long)indexPath.row);
//    return indexPath;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
