//
//  HomePageViewController.h
//  ListeningStory
//
//  Created by 丁伟 on 15/11/20.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"

@interface HomePageViewController : BaseViewController{

}
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSMutableArray *modelList;
@property (nonatomic,strong) AVAudioPlayer *player;
@end
