//
//  DBManager.h
//  Test003
//
//  Created by 丁伟 on 15/11/4.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMResultSet;

@interface DBManager : NSObject
#pragma mark --初始化
+(instancetype) sharedDBManager;
#pragma mark --检索
-(FMResultSet *)selectdata ;
#pragma mark --插入
-(BOOL) insertDBWithDic:(NSArray *)args;
#pragma mark --删除
-(BOOL) delete:(NSArray *)index;
@end
