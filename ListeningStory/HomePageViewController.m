//
//  HomePageViewController.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/20.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "HomePageViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UMSocialSnsPlatformManager.h"
#import "UIViewController+MMDrawerController.h"
#import "ASIHTTPRequest.h"
#import "UMSocialSnsService.h"
#import "UIImageView+WebCache.h"
#import "Tools.h"
#import "MyControls.h"

#import "DBManager.h"
#import "BaseModel.h"


#define URL  @"http://www.html-js.com/music/%d.json"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HIGHT [UIScreen mainScreen].bounds.size.height
#define WEBPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"]
#define CACHEPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"]
#define MAX_PAGE 200
#define TOP_HIGHT 64
#define BOTTON_HIGHT 141

@interface HomePageViewController ()<UMSocialUIDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate>{
ASIHTTPRequest *asiHttpRequest;
unsigned long long Recordull;
//是正在否播放，default is NO
BOOL isPlay;

}

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,strong) BaseModel *baseModel;

@property (nonatomic,strong) UIButton *bookMark;
@property (nonatomic,strong) UIButton *playPre;
@property (nonatomic,strong) UIButton *play;
@property (nonatomic,strong) UIButton *playNext;
@property (nonatomic,strong) UIButton *bookStorage;
@property (nonatomic,strong) UILabel *playedTime;
@property (nonatomic,strong) UILabel *remainTime;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *bookreaded;
@property (nonatomic,strong) UILabel *bookIndex;
@property (nonatomic,strong) UIActivityIndicatorView *activity;

@property (nonatomic,strong) NSMutableArray *imageViews;


@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSTimer *sliderTimer;
@end

@implementation HomePageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //取得网络状态
    [self getNetStatus];

}

-(instancetype)init{
    if (self =[super init]) {
        _imageViews = [NSMutableArray array];
        
        //        //取得网络状态
        //        [self getNetStatus];
        if (![_modelList count]) {
            [self getData];
        }
        //       [self getData];
        [self configUI];
    }
    return self;
}

- (void)getNetStatus{
    
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    NSString *statusStr;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    NSLog(@"----%d", type);
    switch (type) {
        case 0:
            statusStr =@"当前没有可以使用的网络";
            break;
        case 1:
            statusStr =@"当前使用的2G网络";
            break;
        case 2:
            statusStr =@"当前使用的3G网络";
            break;
        case 3:
            statusStr =@"当前使用的4G网络";
            break;
        case 5:
            statusStr =@"当前使用的WIFI网络";
            break;
        default:
            break;
    }
    
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提醒" message:statusStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark --找到当前视图的父视图
-(MMDrawerController*)mm_drawerController{
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil) {
        if([parentViewController isKindOfClass:[MMDrawerController class]]){
            return (MMDrawerController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

#pragma mark --配置界面
-(void)configUI
{
    //创建数据库
    _dbManager =[DBManager sharedDBManager];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HIGHT -BOTTON_HIGHT-TOP_HIGHT)];
    MyControls *myControls =[[MyControls alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), WIDTH, BOTTON_HIGHT)];
    
    //配置导航栏
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    [self.navigationItem setTitle:@"故事书"];
    
    scrollView.delegate = self;
    _scrollView =scrollView;
    
    //查看绘本内容控件
    _bookMark =(UIButton *)[myControls viewWithTag:100];
    
    //前一首控件
    _playPre =(UIButton *)[myControls viewWithTag:101];
    
    //播放控件
    _play =(UIButton *)[myControls viewWithTag:102];
    
    //下一首控件
    _playNext =(UIButton *)[myControls viewWithTag:103];
    
    //收藏控件
    _bookStorage =(UIButton *)[myControls viewWithTag:104];
    
    //已经播放时间控件
    _playedTime =(UILabel *)[myControls viewWithTag:105];
    
    //剩余时间控件
    _remainTime =(UILabel *)[myControls viewWithTag:106];
    
    //进度控制控件
    _slider =(UISlider *)[myControls viewWithTag:107];
    _slider.value =0.0f;
    _slider.enabled =NO;
    
    //浏览次数控件
    _bookreaded =(UILabel *)[myControls viewWithTag:108];
    
    [_bookreaded setTintColor:[UIColor grayColor]];
    [_bookreaded setFont:[UIFont systemFontOfSize:10.0f]];
    
    //绘本索引控件
    _bookIndex =(UILabel *)[myControls viewWithTag:109];
    
    [_bookIndex setTintColor:[UIColor grayColor]];
    [_bookIndex setFont:[UIFont systemFontOfSize:10.0f]];
    
    //Indicator控件
    _activity =(UIActivityIndicatorView *)[myControls viewWithTag:110];
    
    //添加浏览绘本事件
    [_bookMark addTarget:self action:@selector(bookView) forControlEvents:UIControlEventTouchUpInside];
    
    //添加播放事件
    [_play addTarget:self action:@selector(videoPlay) forControlEvents:UIControlEventTouchUpInside];
    
    //添加前一首事件
    [_playPre addTarget:self action:@selector(videoPlayPre) forControlEvents:UIControlEventTouchUpInside];
    
    //添加后一首事件
    [_playNext addTarget:self action:@selector(videoPlayNext) forControlEvents:UIControlEventTouchUpInside];
    
    //添加收藏绘本事件
    [_bookStorage addTarget:self action:@selector(booksStorage) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加进度条变化事件
    [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:myControls];
    [self.view addSubview:scrollView];
    
    for(int i = 0; i < 3; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, _scrollView.frame.size.height)];
        
        [scrollView addSubview:imgView];
        [_imageViews addObject:imgView];
    }
    
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(WIDTH*3, 0);
    scrollView.contentOffset = CGPointMake(WIDTH, 0);
    scrollView.pagingEnabled = YES;
    
    [self showImageByIndex:_currentIndex];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    //    [rightDrawerButton setImage:[UIImage imageNamed:@"icon_share_gary"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [rightDrawerButton setImage:[UIImage imageNamed:@"icon_share_gary"]];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"56584ab1e0f55a13dd003651"
//                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，www.umeng.com/social"
//                                     shareImage:[UIImage imageNamed:@"Icon.png"]
//                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite] delegate:self];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"大家一起来听故事吧!"
                                     shareImage:[UIImage imageNamed:@"Icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,nil]
                                       delegate:self];
}

#pragma mark--计算翻页画面真实的索引
-(NSInteger)trueIndexFromIndex:(NSInteger)index
{
    if(index==-1)
    {
        return _modelList.count-1;
    }
    else if(index == _modelList.count)
    {
        return 0;
    }
    return index;
}

#pragma mark--显示画面
-(void)showImageByIndex:(NSInteger)index
{
    for(int i = -1;i <= 1; i++)
    {
        BaseModel *basemodel =_modelList[[self trueIndexFromIndex:index+i]];
        if (i ==0) {
            _baseModel =basemodel;
            [_bookreaded setText:[NSString stringWithFormat:@"浏览次数:%ld",(long)[_baseModel.visit_count integerValue]]];
            [_bookIndex setText:[NSString stringWithFormat:@"第%ld期",(long)[_baseModel.index integerValue]]];
            NSLog(@"baseModel.index =%@",_baseModel.index);
        }
        
        UIImageView *imgView = _imageViews[i+1];
        
        //        [imgView sd_setImageWithURL:[NSURL URLWithString:[basemodel.cover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"]];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[basemodel.cover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageRetryFailed];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    if(contentOffset.x == 0)
    {
        _currentIndex = [self trueIndexFromIndex:_currentIndex-1];
    }
    else if(contentOffset.x == WIDTH*2)
    {
        _currentIndex = [self trueIndexFromIndex:_currentIndex+1];
    }
    [self showImageByIndex:_currentIndex];
    scrollView.contentOffset = CGPointMake(WIDTH, 0);
    
    [self reSetMyControls];
}

#pragma mark --scrollView滑动停止后重置界面
-(void)reSetMyControls{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:_baseModel.index]) {
        [_bookStorage setBackgroundImage:[UIImage imageNamed:@"flower-256"] forState:UIControlStateNormal];
    }else{
        [_bookStorage setBackgroundImage:[UIImage imageNamed:@"flower-2-256"] forState:UIControlStateNormal];
    }
    
    isPlay =NO;
    [_player stop];
    _player =nil;
    [_play setBackgroundImage:[UIImage imageNamed:@"play-256"] forState:UIControlStateNormal];
    
    if ([_activity isAnimating]) {
        [_activity stopAnimating];
    }
    _slider.value =0.0f;
    _slider.enabled =NO;
    
    [_playedTime setText:[self timeChanged:0]];
    [_remainTime setText:[self timeChanged:0]];
    
    [_sliderTimer invalidate];
    _sliderTimer =nil;
    
}

#pragma mark --获取网络数据
-(void)getData{
    
    _modelList =[NSMutableArray array];
    for (int i =1; i <= MAX_PAGE; i ++) {
        NSString *url =[NSString stringWithFormat:URL,i];
        ASIHTTPRequest *httpRequest =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        NSLog(@"url =%@",url);
        
        httpRequest.delegate =self;
        [httpRequest startSynchronous];
        
    }
    for (int i =0; i <[_modelList count] -1; i ++) {
        for (int j = i +1; j <[_modelList count]; j ++) {
            BaseModel *model1 =_modelList[i];
            BaseModel *model2 =_modelList[j];
            if (model1.index.intValue >model2.index.intValue) {
                [_modelList exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
        BaseModel *model3 =_modelList[i];
        NSLog(@"model3 =%@",model3.index);
    }
}

#pragma mark 浏览绘本
- (void)bookView{
    [Tools showMessage:@"当前绘本没有预览O(∩_∩)O"];
}

#pragma mark 播放音乐
- (void)videoPlay{
    
    _slider.enabled =YES;
    NSLog(@"%@",CACHEPATH);
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:WEBPATH])
    {
        [fileManager createDirectoryAtPath:WEBPATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:CACHEPATH])
    {
        [fileManager createDirectoryAtPath:CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[CACHEPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",_baseModel.index]]]) {
        
        [self configPlayer];
        [self playMusic];
    }else{
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[_baseModel.audio stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        //下载完存储目录
        [request setDownloadDestinationPath:[CACHEPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",_baseModel.index]]];
        
        //临时存储目录
        [request setTemporaryFileDownloadPath:[WEBPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",_baseModel.index]]];
        
        __weak typeof (request)requestbk =request;
        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
            NSLog(@"Recordull=%llu" ,Recordull);
            NSLog(@"total=%llu" ,total);
            
            [_activity startAnimating];
            self.view.userInteractionEnabled =NO;
            
            _slider.maximumValue = _player.duration;
            //            [musicBt stopSpin];
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //            [userDefaults setDouble:total forKey:@"file_length"];
            
            //Recordull全局变量，记录已下载的文件的大小
            Recordull += size;
        }];
        [request setCompletionBlock:^{
            
            [_activity stopAnimating];
            self.view.userInteractionEnabled =YES;
            Recordull =0.0f;
            asiHttpRequest =nil;
            
            [self configPlayer];
            [self playMusic];
        }];
        
        [request setFailedBlock:^{
            
            //清理到下载失败的缓存文件
            [Tools clearCache:[requestbk temporaryFileDownloadPath]];
            [Tools clearCache:[requestbk downloadDestinationPath]];
            [self reSetMyControls];
            asiHttpRequest =nil;
            
            NSLog(@"下载音乐失败：%@",asiHttpRequest.error.localizedDescription);
        }];
        //断点续载
        [request setAllowResumeForFileDownloads:YES];
        [request startAsynchronous];
        asiHttpRequest = request;
    }
}

#pragma mark 播放前一首音乐
- (void)videoPlayPre{
    _scrollView.contentOffset = CGPointMake(0, 0);
    [self scrollViewDidEndDecelerating:_scrollView];
}

#pragma mark 播放后一首音乐
- (void)videoPlayNext{
    _scrollView.contentOffset = CGPointMake(WIDTH *2, 0);
    [self scrollViewDidEndDecelerating:_scrollView];
}

#pragma mark 收藏绘本
- (void)booksStorage{
    NSArray *args1 =@[_baseModel.index,_baseModel.desc,_baseModel.audio,_baseModel.cover,_baseModel.title,_baseModel.visit_count];
    NSArray *args2 =@[_baseModel.index];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:_baseModel.index]) {
        
        //收藏当前绘本
        [_bookStorage setBackgroundImage:[UIImage imageNamed:@"flower-2-256"] forState:UIControlStateNormal];
        
        if ([_dbManager insertDBWithDic:args1]) {
            [defaults setBool:YES forKey:_baseModel.index];
            [defaults synchronize];
            [Tools showMessage:@"收藏完毕当前绘本"];
            NSLog(@"收藏当前绘本：%@",_baseModel.title);
        }else{
            [Tools showMessage:@"收藏失败"];
        }
    }else{
        
        //取消收藏当前绘本
        [_bookStorage setBackgroundImage:[UIImage imageNamed:@"flower-256"] forState:UIControlStateNormal];
        
        if ([_dbManager delete:args2]) {
            [defaults setBool:NO forKey:_baseModel.index];
            [defaults synchronize];
            [Tools showMessage:@"取消收藏当前绘本"];
            NSLog(@"取消收藏当前绘本：%@",_baseModel.title);
        }else{
            [Tools showMessage:@"取消收藏失败"];
        }
        
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"请求的数据：%@",[request responseString]);
    BaseModel *baseModel =[[BaseModel alloc]initWithString:request.responseString error:nil];
    if (baseModel) {
        [_modelList addObject:baseModel];
    }
}

//-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
//    NSLog(@"2 =%@",data);
//}

-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求失败：%@",request.error.localizedDescription);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --配置播放器
-(void)configPlayer{
    if (!_player) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[CACHEPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",_baseModel.index]]] error:nil];
        _player.delegate =self;
        [_player prepareToPlay];
        [_player setNumberOfLoops:-1];
        _slider.maximumValue = _player.duration;
    }
}

#pragma mark --播放下载的音乐
-(void)playMusic{
    isPlay =!isPlay;
    if (isPlay) {
        [_play setBackgroundImage:[UIImage imageNamed:@"pause-256"] forState:UIControlStateNormal];
        [_player play];
        if (!_sliderTimer) {
            _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        }
        _player.currentTime =_slider.value;
        
    }else{
        [_sliderTimer invalidate];
        _sliderTimer =nil;
        
        [_play setBackgroundImage:[UIImage imageNamed:@"play-256"] forState:UIControlStateNormal];
        [_player pause];
    }
}

#pragma mark--更新slider的位置
- (void)updateSlider {

    _slider.value = _player.currentTime;
    [_playedTime setText:[self timeChanged:_slider.value]];
    [_remainTime setText:[self timeChanged:_player.duration- _slider.value]];
    NSLog(@"currentTime%f",_player.currentTime);
}

#pragma mark--滑动slider会触发这个事件
-(void)sliderChanged:(UISlider *)sender {
    if (_player.isPlaying) {
        [_player stop];
    }
    
    _slider.value =sender.value;
    
    [_player setCurrentTime:sender.value];
    [_play setBackgroundImage:[UIImage imageNamed:@"pause-256"] forState:UIControlStateNormal];
    [_player prepareToPlay];
    [_player play];
    isPlay =YES;
    
    if (!_sliderTimer) {
        _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
}

//实现回调方法（可选）：
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}

// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
#pragma mark--音频播放完毕会触发这个事件
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//    if (flag) {
//        [_play setBackgroundImage:[UIImage imageNamed:@"play-256"] forState:UIControlStateNormal];
//        
//        _slider.value =0;
//        
//        [_playedTime setText:[self timeChanged:_slider.value]];
//        [_remainTime setText:[self timeChanged:_player.duration- _slider.value]];
//        
//        [_sliderTimer invalidate];
//        _sliderTimer =nil;
//    }
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex ==0) {
//        assert(<#e#>)
//    }
//}

#pragma mark --时间转换
-(NSString *)timeChanged:(NSTimeInterval)time{
    
    int mi;
    int mm;
    mi =time/60;
    mm =(int)time%60;
    
    return [NSString stringWithFormat:@"%02d:%02d",mi,mm];
}

@end
