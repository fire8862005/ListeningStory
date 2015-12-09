//
//  ContactMeViewController.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/27.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "ContactMeViewController.h"

@interface ContactMeViewController ()

@end

@implementation ContactMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title =@"联系我们";
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(10, 20, 50, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonbar_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
