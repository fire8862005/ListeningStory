//
//  MyControls.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/23.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "MyControls.h"
@interface MyControls()
@property (nonatomic,strong) MyControls *myControls;
@end
@implementation MyControls

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        _myControls =[[[NSBundle mainBundle]loadNibNamed:@"MyControls" owner:self options:nil] firstObject];
        _myControls.frame =frame;
    }
    
    return _myControls;
}

@end
