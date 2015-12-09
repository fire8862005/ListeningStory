//
//  BaseModel.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/20.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"idStr"}];
}
@end
