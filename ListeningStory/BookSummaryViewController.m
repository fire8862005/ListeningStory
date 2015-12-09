//
//  BookSummaryViewController.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/26.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "BookSummaryViewController.h"
#import "SummaryTableViewCell.h"
#import "BaseModel.h"
#import "SummaryModel.h"
@interface BookSummaryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *bookSummaryTableView;
@end

@implementation BookSummaryViewController
static NSString *idStr =@"SummaryCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bookSummaryTableView =self.tableView;
    self.view.backgroundColor =[UIColor colorWithRed:0.951 green:0.935 blue:0.812 alpha:1.000];
    //    _bookSummaryTableView.backgroundColor =[UIColor colorWithRed:0.951 green:0.935 blue:0.812 alpha:1.000];
    _bookSummaryTableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
    [_bookSummaryTableView registerNib:[UINib nibWithNibName:@"SummaryTableViewCell" bundle:nil]  forCellReuseIdentifier:idStr];
    self.navigationItem.title =@"所有绘本";
    //    self.navigationController.navigationBar.backgroundColor =[UIColor colorWithRed:211.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.000];
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(10, 20, 50, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonbar_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datalist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr forIndexPath:indexPath ];
    
    BaseModel *baseModel =_datalist[indexPath.row];
    SummaryModel *summaryModel = [[SummaryModel alloc]init];
    summaryModel.imageUrl =baseModel.cover;
    summaryModel.storyTitle =baseModel.title;
    summaryModel.count =baseModel.visit_count;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
