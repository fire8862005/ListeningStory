//
//  OtherUsefulItemsViewController.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/25.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIViewController+MMDrawerController.h"
#import "HomePageViewController.h"
#import "OtherUsefulItemsViewController.h"
#import "BookSummaryViewController.h"
#import "MyStorageTableViewController.h"
#import "ContactMeViewController.h"

#import "Tools.h"
#import "DBManager.h"
#import "FMDatabase.h"
#import "BaseModel.h"
#import "SummaryModel.h"
#import "UIImageView+WebCache.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HIGHT [UIScreen mainScreen].bounds.size.height

//清理缓存
#define TMPPATH [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
#define WEBPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents"]
#define CACHEPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]

@interface OtherUsefulItemsViewController ()
@property (strong,nonatomic) BookSummaryViewController *bookSummaryController;
@property (strong,nonatomic) MyStorageTableViewController *myStorageTableViewController;

@property (nonatomic,strong) DBManager *dbManager;
@property (strong, nonatomic) IBOutlet UIButton *summaries;
@property (strong, nonatomic) IBOutlet UIButton *myStories;
@property (strong, nonatomic) IBOutlet UIButton *versionUpdate;
@property (strong, nonatomic) IBOutlet UIButton *callUs;
@property (strong, nonatomic) IBOutlet UIButton *cleanCache;

@end

@implementation OtherUsefulItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"其他"];
}

-(instancetype)init{
    if (self =[super init]) {
        _bookSummaryController =[[BookSummaryViewController alloc]init];
        __weak typeof(_bookSummaryController) weakSelf = _bookSummaryController;
        _getDataListBlock =^(NSMutableArray *summaries){
            weakSelf.datalist =summaries;
        };
    }
    return  self;
}

//-(MMDrawerController*)mm_drawerController{
//    UIViewController *parentViewController = self.parentViewController;
//    while (parentViewController != nil) {
//        if([parentViewController isKindOfClass:[MMDrawerController class]]){
//            return (MMDrawerController *)parentViewController;
//        }
//        parentViewController = parentViewController.parentViewController;
//    }
//    return nil;
//}

#pragma mark --弹出视图风格
-(void)presentStyle:(UIViewController *)vc{
    [self.mm_drawerController presentViewController:vc animated:YES completion:^{
        vc.view.backgroundColor =[UIColor colorWithRed:0.955 green:0.944 blue:0.845 alpha:1.000];
    }];
}

#pragma mark --所有绘本
- (IBAction)getAllBooks:(id)sender {
    BaseNavigationController *nav =[[BaseNavigationController alloc]initWithRootViewController:_bookSummaryController];
    nav.navigationItem.title =@"我的收藏";
    [self presentStyle:nav];
    
}

#pragma mark --我的收藏
- (IBAction)showMyBooks:(id)sender {
    _dbManager =[DBManager sharedDBManager];
    FMResultSet *result =[_dbManager selectdata];
    
    NSArray *book = [self getMyBooks:result];
    if (![book count]) {
        [Tools showMessage:@"抱歉，您还没有任何收藏"];
    }else{
        _myStorageTableViewController =[[MyStorageTableViewController alloc]init];
        _myStorageTableViewController.dataList =book;
        BaseNavigationController *nav =[[BaseNavigationController alloc]initWithRootViewController:_myStorageTableViewController];
        
        [self presentStyle:nav];
    }
}

#pragma mark --获取我的收藏数据
-(NSArray *)getMyBooks:(FMResultSet *)fmResults{
    
    NSMutableArray *muArr =[NSMutableArray array];
    while ([fmResults next]) {
        SummaryModel *myStorage =[[SummaryModel alloc]init];
        myStorage.imageIndex =[fmResults stringForColumn:@"bookIndex"];
        myStorage.imageUrl =[fmResults stringForColumn:@"cover"];
        myStorage.storyTitle =[fmResults stringForColumn:@"title"];
        myStorage.count =[fmResults stringForColumn:@"visit_count"];
        [muArr addObject:myStorage];
    }
    NSArray *arr =[NSArray arrayWithArray:muArr];
    return arr;
}
#pragma mark --最新版本
- (IBAction)getLatestVersion:(id)sender {
    [Tools showMessage:@"已经是最新版本"];
}

#pragma mark --清理缓存
- (IBAction)cleanCache:(id)sender {
    UINavigationController *navigationController =(UINavigationController *)[[self mm_drawerController ]centerViewController];
    NSLog(@"%@",navigationController.viewControllers);
    HomePageViewController *homePageViewController = (HomePageViewController *)[navigationController.viewControllers firstObject];
    
    if ([homePageViewController.player isPlaying]) {
        [Tools showMessage:@"音乐正在播放，请先停止播放"];
    }else{
        //沙盒下Tmp下文件大小
        float tmpSize = [Tools folderSizeAtPath:TMPPATH];
        //沙盒下Document下Temp文件大小
        float tempSize = [Tools folderSizeAtPath:WEBPATH];
        //沙盒下Document下Cache文件大小
        float cacheSize = [Tools folderSizeAtPath:CACHEPATH];
        
        if (tmpSize +tempSize +cacheSize >0.0f ) {
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存大小为%fM.确定要清理吗？",tmpSize +tempSize +cacheSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{
            [Tools showMessage:@"没有可以清理的缓存。"];
        }
    }
    
}

#pragma mark --联系我们
- (IBAction)contactUs:(id)sender {
    ContactMeViewController *contactMeViewController =[[ContactMeViewController alloc]init];
    BaseNavigationController *nav =[[BaseNavigationController alloc]initWithRootViewController:contactMeViewController];
    
    [self presentStyle:nav];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        [Tools clearCache:TMPPATH];
        [Tools clearCache:WEBPATH];
        [Tools clearCache:CACHEPATH];
        
        [[SDImageCache sharedImageCache] cleanDisk];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
