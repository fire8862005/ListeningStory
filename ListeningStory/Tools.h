//
//  Tools.h
//  ListeningStory
//
//  Created by 丁伟 on 15/11/26.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tools : UIView

#pragma mark --显示特定的提示性的message
+(void)showMessage:(NSString *)message;
#pragma mark --计算目录大小
+ (float )folderSizeAtPath:(NSString*) folderPath;
#pragma mark --清理
+(void)clearCache:(NSString *)path;
@end
