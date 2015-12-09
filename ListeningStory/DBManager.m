//
//  DBManager.m
//  Test003
//
//  Created by 丁伟 on 15/11/4.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
static DBManager *db;
@interface DBManager()
@property (nonatomic,strong) FMDatabase *fmdb;
@end

@implementation DBManager

+(instancetype) sharedDBManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!db) {
            db = [[DBManager alloc]init];
        }
    });
    
    return db;
}

-(instancetype) init{
    if (self = [super init]) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ListeningStory.db"];
        
        _fmdb =[FMDatabase databaseWithPath:path];
        NSLog(@"pth=%@",path);
        BOOL isSuccess = [_fmdb open];
        if (isSuccess) {
            BOOL result=[_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_listeningStory (bookIndex integer PRIMARY KEY AUTOINCREMENT NOT NULL,'desc' VARCHAR(500),'audio' VARCHAR(250),'cover' VARCHAR(250), 'title' VARCHAR(60), visit_count integer)"];
            
            if (!result) {
                NSLog(@"table创建失败");
            }else{
                 NSLog(@"table创建成功");
                }
        }else{
            
            NSLog(@"数据库创建失败");
        }
    }
    return self;
}

#pragma mark --检索
-(FMResultSet *)selectdata {
    NSString *selectSql = @"SELECT * FROM t_listeningStory";
    FMResultSet *resultSet = [_fmdb executeQuery:selectSql];
    NSLog(@"检索结果:%@",resultSet);
    if (resultSet) {
        return resultSet;
    }
    return nil;
}

#pragma mark --插入
-(BOOL) insertDBWithDic:(NSArray *)args{
    NSString *insertSql = @"insert into t_listeningStory(bookIndex,desc,audio,cover,title,visit_count) values(?,?,?,?,?,?)";
    BOOL success = [_fmdb executeUpdate:insertSql withArgumentsInArray:args];
    if (success) {
//        [_fmdb commit];
        NSLog(@"插入一条数据");
    }else{
        NSLog(@"插入失败:%@",[_fmdb lastErrorMessage]);
        
    }
    return success;
}

#pragma mark --删除
-(BOOL) delete:(NSArray *)bookIndex{
    NSString *deleteSql = @"DELETE FROM  t_listeningStory WHERE bookIndex = ?";
    BOOL success = [_fmdb executeUpdate:deleteSql withArgumentsInArray:bookIndex];
    if (success) {
//        [_fmdb commit];
        NSLog(@"删除一条数据");
    }else{
        NSLog(@"删除失败:%@",[_fmdb lastErrorMessage]);
    }
    return success;
}
@end
