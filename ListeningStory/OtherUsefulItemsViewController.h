//
//  OtherUsefulItemsViewController.h
//  ListeningStory
//
//  Created by 丁伟 on 15/11/25.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectedBlock)(NSMutableArray *summaries);
@interface OtherUsefulItemsViewController : UIViewController
@property (nonatomic,strong)selectedBlock getDataListBlock;
@end
