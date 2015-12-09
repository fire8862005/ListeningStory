//
//  TopMenu.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/24.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "TopMenu.h"
@interface TopMenu()
@property (nonatomic,strong) TopMenu *myMenus;
@end
@implementation TopMenu

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        _myMenus =[[[NSBundle mainBundle]loadNibNamed:@"TopMenu" owner:self options:nil] firstObject];
        _myMenus.frame =frame;
    }
    
    return _myMenus;
}

@end
